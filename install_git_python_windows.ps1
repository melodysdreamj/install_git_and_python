# 해당 함수 호출 시 최신 버전의 Python 정보 제공
function Get-LatestPythonVersion() {
    $chocoPackages = choco list python --allversions --exact
    $choco310 = $chocoPackages | Select-String -Pattern 'python v3\.10\.'
    $splitVersions = $choco310 -split "`n"
    $matchVersions = $splitVersions | ForEach-Object { ($_ -split " ")[1] -replace 'v', '' }

    $maxVersion = [System.Version]::new(0, 0, 0, 0)
    foreach ($ver in $matchVersions) {
        $tempVersion = [System.Version]::new($ver)
        if ($tempVersion -gt $maxVersion) {
            $maxVersion = $tempVersion
        }
    }

    if ($maxVersion -eq [System.Version]::new(0, 0, 0, 0)) {
        return $null
    } else {
        return $maxVersion.ToString()
    }
}

# Execution Policy 변경
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
Write-Host 'Execution Policy changed to Unrestricted.'

# Chocolatey 설치 확인 및 설치
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host 'Chocolatey not found. Installing...'
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host 'Chocolatey installed.'
} else {
    Write-Host 'Chocolatey is already installed.'
}

# Git 설치 확인 및 설치
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host 'Git not found. Installing...'
    choco install git -y
    # 환경 변수 설정
    $path = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
    if (-not ($path -like "*C:\Program Files\Git\cmd*")) {
        $path += ";C:\Program Files\Git\cmd"
        [Environment]::SetEnvironmentVariable('Path', $path, [EnvironmentVariableTarget]::Machine)
    }
    Write-Host 'Git installed.'
} else {
    Write-Host 'Git is already installed.'
}



# 최신 Python 버전 가져오기
$latest_python_version = Get-LatestPythonVersion

# Python 3.10.x 설치 확인 및 설치
$installed_python_version = & python --version 2>$null
$required_python_version = '3.10.6'

# 더 최신 버전이 있다면 그대로 사용
if ($latest_python_version.Gt($required_python_version)) {
    $required_python_version = $latest_python_version
}

if ($installed_python_version -notlike "*$required_python_version*") {
    Write-Host "Required Python version not found. Installing Python $required_python_version..."
    choco install python --version=$required_python_version -y --allow-downgrade
    $env:Path += ';C:\Python310\Scripts\'
    $env:Path += ';C:\Python310\'
    Write-Host 'Python installed.'
} else {
    Write-Host 'Required Python version is already installed.'
}

Write-Host 'Press any key to exit.'
cmd /c pause | out-null
