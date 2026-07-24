[CmdletBinding()]
param(
    [switch]$ProjectOnly,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Assert-Command {
    param([Parameter(Mandatory = $true)][string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "No se encontro '$Name' en PATH. Instala Node.js LTS y abre una nueva terminal."
    }
}

Assert-Command -Name "node"
Assert-Command -Name "npm"
Assert-Command -Name "npx"
Assert-Command -Name "git"

Write-Host "Configurando skills base para Codex..." -ForegroundColor Cyan
Write-Host "Node: $(node --version)"
Write-Host "npm:  $(npm --version)"
Write-Host "Git:  $(git --version)"

$arguments = @(
    "--yes",
    "skills",
    "add",
    "anthropics/skills",
    "--agent",
    "codex",
    "--yes"
)

if (-not $ProjectOnly) {
    $arguments += "--global"
}

if ($Force) {
    $arguments += "--force"
}

& npx @arguments

if ($LASTEXITCODE -ne 0) {
    throw "La instalacion de anthropics/skills termino con codigo $LASTEXITCODE."
}

Write-Host "Skills instaladas correctamente para Codex." -ForegroundColor Green

try {
    & npx --yes skills list
}
catch {
    Write-Warning "La instalacion finalizo, pero no se pudo ejecutar 'npx skills list'."
}
