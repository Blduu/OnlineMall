param (
    [string]$Version = "1.0.0",
    [string]$ServerIp,
    [string]$ServerUser = "root",
    [string]$ServerPassword
)

# Log output function
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
    Add-Content -Path "deploy.log" -Value "[$timestamp] [$Level] $Message"
}

# Error handling function
function Handle-Error {
    param (
        [string]$Step,
        [string]$ErrorMsg
    )
    Write-Log "Error during $Step`: $ErrorMsg" "ERROR"
    exit 1
}

# Check required parameters
if (-not $ServerIp) {
    Handle-Error "Parameter Validation" "Server IP is required. Use -ServerIp parameter."
}

if (-not $ServerPassword) {
    $SecurePassword = Read-Host -AsSecureString "Enter server password:"
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
    $ServerPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
}

# Initialize log
$dateStr = Get-Date -Format "yyyyMMdd_HHmmss"
New-Item -Path "deploy.log" -ItemType File -Force | Out-Null
Write-Log "Starting OnlineMall deployment, version: $Version"

# 1. Build backend
Write-Log "Building backend project..."
Set-Location -Path ".\OnlineMall-backend"
mvn clean package -DskipTests
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Backend Build" "Backend build failed"
}
Write-Log "Backend build successful"
Set-Location -Path ".."

# 2. Build frontend
Write-Log "Building frontend project..."
Set-Location -Path ".\OnlineMall-frontend"
npm install
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Frontend Build" "Frontend dependency installation failed"
}
npm run build
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Frontend Build" "Frontend build failed"
}
Write-Log "Frontend build successful"
Set-Location -Path ".."

# 3. Build Docker images
Write-Log "Building Docker images..."

# Build backend image
docker build -t onlinemall-backend:$Version ./OnlineMall-backend
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Docker Build" "Backend Docker image build failed"
}

# Build frontend image
docker build -t onlinemall-frontend:$Version ./OnlineMall-frontend
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Docker Build" "Frontend Docker image build failed"
}

Write-Log "Docker images built successfully"

# 4. Pull and save base images (MySQL and Redis)
Write-Log "Pulling MySQL and Redis images from Docker Hub..."
docker pull mysql:8.4.5
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Docker Pull" "Failed to pull MySQL image"
}

docker pull redis:8.0.1
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Docker Pull" "Failed to pull Redis image"
}

# 5. Save all Docker images
Write-Log "Saving Docker images to files..."
docker save -o onlinemall-backend-$Version.tar onlinemall-backend:$Version
docker save -o onlinemall-frontend-$Version.tar onlinemall-frontend:$Version
docker save -o mysql-8.4.5.tar mysql:8.4.5
docker save -o redis-8.0.1.tar redis:8.0.1
Write-Log "Images saved successfully"

# 6. Check if SSH is available
if (-not (Get-Command "ssh" -ErrorAction SilentlyContinue)) {
    Handle-Error "Tools" "OpenSSH client not found. Please install OpenSSH or Git for Windows"
}

# Configure SSH to disable strict host checking
$sshConfig = @"
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
"@
$sshDir = "$env:USERPROFILE\.ssh"
if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir | Out-Null
}
Set-Content -Path "$sshDir\config" -Value $sshConfig -Force

# Create temporary script to handle SSH password
$tempDir = [System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString()
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
$passwordFile = "$tempDir\password.txt"
Set-Content -Path $passwordFile -Value $ServerPassword -NoNewline

# Create SSH helper function
function Invoke-SshCommand {
    param(
        [string]$Command
    )
    
    Write-Log "Running SSH command: [MASKED COMMAND]"
    
    # Use sshpass (if available) or direct password method
    if (Get-Command "sshpass" -ErrorAction SilentlyContinue) {
        $result = Invoke-Expression "sshpass -f $passwordFile ssh $ServerUser@$ServerIp '$Command'"
    }
    else {
        # For Windows without sshpass, use direct SSH (will prompt for password)
        $result = ssh $ServerUser@$ServerIp $Command
    }
    
    return $result
}

function Copy-ToServer {
    param(
        [string]$Source,
        [string]$Destination
    )
    
    Write-Log "Copying $Source to $Destination"
    
    # Use sshpass (if available) or direct password method
    if (Get-Command "sshpass" -ErrorAction SilentlyContinue) {
        $result = Invoke-Expression "sshpass -f $passwordFile scp $Source $ServerUser@$ServerIp`:$Destination"
    }
    else {
        # For Windows without sshpass, use direct SCP (will prompt for password)
        $result = scp $Source $ServerUser@$ServerIp`:$Destination
    }
    
    return $LASTEXITCODE
}

# 7. Prepare server environment
Write-Log "Preparing server environment..."
$serverPrep = Invoke-SshCommand -Command "mkdir -p /root/deploy /root/OnlineMall-backend/avatar /root/OnlineMall-backend/file /root/OnlineMall-backend/sql"

# Transfer Docker images
Write-Log "Transferring backend image... (this may take a while)"
$result = Copy-ToServer -Source "onlinemall-backend-$Version.tar" -Destination "/root/deploy/"
if ($result -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "File Transfer" "Failed to transfer backend image"
}

Write-Log "Transferring frontend image... (this may take a while)"
$result = Copy-ToServer -Source "onlinemall-frontend-$Version.tar" -Destination "/root/deploy/"
if ($result -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "File Transfer" "Failed to transfer frontend image"
}

Write-Log "Transferring MySQL image... (this may take a while)"
$result = Copy-ToServer -Source "mysql-8.4.5.tar" -Destination "/root/deploy/"
if ($result -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "File Transfer" "Failed to transfer MySQL image"
}

Write-Log "Transferring Redis image... (this may take a while)"
$result = Copy-ToServer -Source "redis-8.0.1.tar" -Destination "/root/deploy/"
if ($result -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "File Transfer" "Failed to transfer Redis image"
}

# Transfer avatar and file directories
Write-Log "Transferring avatar and file directories... (this may take a while)"
$result = Copy-ToServer -Source "./OnlineMall-backend/avatar/*" -Destination "/root/OnlineMall-backend/avatar/"
if ($result -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "File Transfer" "Failed to transfer avatar files"
}

$result = Copy-ToServer -Source "./OnlineMall-backend/file/*" -Destination "/root/OnlineMall-backend/file/"
if ($result -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "File Transfer" "Failed to transfer system files"
}

Write-Log "Transferring configuration files..."
# First update the docker-compose.yml file to remove the version field
$dockerCompose = Get-Content -Path "docker-compose.yml" -Raw
$dockerCompose = $dockerCompose -replace "version: '3.8'\s*\n", ""
Set-Content -Path "$tempDir\docker-compose.yml" -Value $dockerCompose -Encoding ASCII

$result = Copy-ToServer -Source "$tempDir\docker-compose.yml" -Destination "/root/"
if ($result -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "File Transfer" "Failed to transfer docker-compose.yml"
}

$result = Copy-ToServer -Source "./OnlineMall-backend/sql/DB_OnlineMall.sql" -Destination "/root/OnlineMall-backend/sql/"
if ($result -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "File Transfer" "Failed to transfer SQL file"
}

# 8. Create deployment script
Write-Log "Creating deployment script..."
$deployScriptPath = "$tempDir\deploy_script.sh"
$stream = [System.IO.File]::OpenWrite($deployScriptPath)
$writer = New-Object System.IO.StreamWriter($stream, [System.Text.Encoding]::ASCII)
$writer.NewLine = "`n"  # Use Unix line endings (LF only)

# Write script contents line by line
$writer.WriteLine("#!/bin/bash")
$writer.WriteLine("set -e")
$writer.WriteLine("")
$writer.WriteLine("echo ""Starting deployment process...""")
$writer.WriteLine("")
$writer.WriteLine("# Create necessary directories")
$writer.WriteLine("mkdir -p /root/OnlineMall-backend/sql")
$writer.WriteLine("mkdir -p /root/OnlineMall-backend/avatar")
$writer.WriteLine("mkdir -p /root/OnlineMall-backend/file")
$writer.WriteLine("")
$writer.WriteLine("# Load all images")
$writer.WriteLine("echo ""Loading Docker images...""")
$writer.WriteLine("docker load -i /root/deploy/onlinemall-backend-$Version.tar")
$writer.WriteLine("docker load -i /root/deploy/onlinemall-frontend-$Version.tar")
$writer.WriteLine("docker load -i /root/deploy/mysql-8.4.5.tar")
$writer.WriteLine("docker load -i /root/deploy/redis-8.0.1.tar")
$writer.WriteLine("")
$writer.WriteLine("# Set environment variables")
$writer.WriteLine("export VERSION=$Version")
$writer.WriteLine("")
$writer.WriteLine("# Stop and remove old containers (preserve data volumes)")
$writer.WriteLine("echo ""Stopping old containers...""")
$writer.WriteLine("docker-compose -f /root/docker-compose.yml down || true")
$writer.WriteLine("")
$writer.WriteLine("# Start new containers")
$writer.WriteLine("echo ""Starting new containers...""")
$writer.WriteLine("docker-compose -f /root/docker-compose.yml up -d mysql")
$writer.WriteLine("echo ""Waiting for MySQL to initialize (10 seconds)...""")
$writer.WriteLine("sleep 10")
$writer.WriteLine("docker-compose -f /root/docker-compose.yml up -d redis")
$writer.WriteLine("sleep 10")
$writer.WriteLine("docker-compose -f /root/docker-compose.yml up -d backend frontend")
$writer.WriteLine("")
$writer.WriteLine("# Clean up")
$writer.WriteLine("echo ""Cleaning up...""")
$writer.WriteLine("rm -rf /root/deploy")
$writer.WriteLine("docker image prune -f")
$writer.WriteLine("")
$writer.WriteLine("echo ""Deployment completed successfully!""")

# Close the writer and stream
$writer.Flush()
$writer.Close()
$stream.Close()

# Upload and execute deployment script
Write-Log "Uploading deployment script..."
$result = Copy-ToServer -Source $deployScriptPath -Destination "/root/deploy_script.sh"
if ($result -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "File Transfer" "Failed to transfer deployment script"
}

Write-Log "Executing deployment script on server..."
$deployResult = Invoke-SshCommand -Command "chmod +x /root/deploy_script.sh && /root/deploy_script.sh"
if ($LASTEXITCODE -ne 0) {
    Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
    Handle-Error "Remote Execution" "Server deployment failed"
}

# Clean up temporary files
Remove-Item -Path $passwordFile -Force -ErrorAction SilentlyContinue
Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path onlinemall-backend-$Version.tar -Force -ErrorAction SilentlyContinue
Remove-Item -Path onlinemall-frontend-$Version.tar -Force -ErrorAction SilentlyContinue
Remove-Item -Path mysql-8.4.5.tar -Force -ErrorAction SilentlyContinue
Remove-Item -Path redis-8.0.1.tar -Force -ErrorAction SilentlyContinue

Write-Log "Deployment completed successfully!"
Write-Log "Frontend access URL: http://$ServerIp"
Write-Log "Backend access URL: http://$ServerIp:8080" 