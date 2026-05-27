<#
.SYNOPSIS
  Automatiza o lancamento de uma nova versao do Bipi.

.DESCRIPTION
  Faz o bump da versao no pubspec.yaml, builda o APK release, copia para
  dist\bipi.apk e mostra (ou executa, com -Publish) os comandos de publicacao
  no GitHub Releases. Como o QR do evento aponta para releases/latest, ele
  passa a servir a versao nova automaticamente — nao precisa regerar o QR.

  Pre-requisitos (no SEU terminal, autenticado):
    - Flutter (em C:\src\flutter ou no PATH)
    - git e gh autenticados na conta dona do repo

.PARAMETER Version
  Versao nova no formato X.Y.Z (ex.: 1.1.1). Precisa ser MAIOR que a atual,
  senao o app nao vai oferecer atualizacao.

.PARAMETER Notes
  Texto das notas do release (sem acento para nao bagunçar no cmd).

.PARAMETER Publish
  Se presente, ja commita o bump, da push e cria o release automaticamente.

.EXAMPLE
  .\dist\release.ps1 1.1.1
  # Faz bump+build+copia e MOSTRA os comandos de publicacao.

.EXAMPLE
  .\dist\release.ps1 1.2.0 -Publish
  # Faz tudo e ja publica (commit + push + gh release create).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version,

    [string]$Notes = 'Atualizacao do Bipi. Android apenas - permita instalar de fontes desconhecidas.',

    [switch]$Publish
)

$ErrorActionPreference = 'Stop'

$repo    = 'MEUCAPSQUEBROU/BipiApp'
$root    = Split-Path $PSScriptRoot -Parent
$pubspec = Join-Path $root 'pubspec.yaml'
$apkSrc  = Join-Path $root 'build\app\outputs\flutter-apk\app-release.apk'
$apkDst  = Join-Path $PSScriptRoot 'bipi.apk'
$tag     = "v$Version"

function Write-Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }

# --- 1. Localiza o Flutter -------------------------------------------------
$flutter = (Get-Command flutter -ErrorAction SilentlyContinue).Source
if (-not $flutter) { $flutter = 'C:\src\flutter\bin\flutter.bat' }
if (-not (Test-Path $flutter)) {
    throw "Flutter nao encontrado em '$flutter'. Ajuste o caminho no topo do script."
}

# --- 1b. Localiza o gh (GitHub CLI) ----------------------------------------
$gh = (Get-Command gh -ErrorAction SilentlyContinue).Source
if (-not $gh) { $gh = 'C:\Program Files\GitHub CLI\gh.exe' }
if ($Publish -and -not (Test-Path $gh)) {
    throw "GitHub CLI (gh) nao encontrado em '$gh'. Instale ou ajuste o caminho."
}

# --- 2. Bump da versao no pubspec ------------------------------------------
$content = Get-Content $pubspec -Raw
$rx = '(?m)^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$'
$m = [regex]::Match($content, $rx)
if (-not $m.Success) { throw "Nao consegui ler a linha 'version:' do pubspec.yaml." }

$oldVer = "$($m.Groups[1].Value).$($m.Groups[2].Value).$($m.Groups[3].Value)"
$build  = [int]$m.Groups[4].Value + 1

# Avisa se a nova versao nao for maior (o app nao oferece update nesse caso).
$o = $oldVer.Split('.') | ForEach-Object { [int]$_ }
$n = $Version.Split('.') | ForEach-Object { [int]$_ }
$greater = ($n[0] -gt $o[0]) -or
           ($n[0] -eq $o[0] -and $n[1] -gt $o[1]) -or
           ($n[0] -eq $o[0] -and $n[1] -eq $o[1] -and $n[2] -gt $o[2])
if (-not $greater) {
    Write-Warning "A nova versao ($Version) NAO e maior que a atual ($oldVer). Quem ja tem a $oldVer nao recebera o aviso de atualizacao."
}

$newLine = "version: $Version+$build"
$content = [regex]::Replace($content, $rx, $newLine)
# Escreve sem BOM para nao incomodar o parser do pubspec.
[System.IO.File]::WriteAllText($pubspec, $content, [System.Text.UTF8Encoding]::new($false))
Write-Step "pubspec: $oldVer  ->  $Version+$build"

# --- 3. Build do APK release -----------------------------------------------
Write-Step 'Buildando APK release (pode levar alguns minutos)...'
Push-Location $root
try { & $flutter build apk --release } finally { Pop-Location }
if ($LASTEXITCODE -ne 0) { throw "Build falhou (exit $LASTEXITCODE)." }
if (-not (Test-Path $apkSrc)) { throw "APK nao encontrado em $apkSrc apos o build." }

# --- 4. Copia o APK para dist\bipi.apk -------------------------------------
Copy-Item $apkSrc $apkDst -Force
$sizeMB = [math]::Round((Get-Item $apkDst).Length / 1MB, 1)
Write-Step "APK copiado para dist\bipi.apk ($sizeMB MB)"

# --- 5. Publicacao ---------------------------------------------------------
$ghCmd = "& '" + $gh + "' release create " + $tag + " '" + $apkDst + "' --repo " +
         $repo + " --title 'Bipi " + $tag + "' --notes '" + $Notes + "'"

Write-Host ''
if ($Publish) {
    Write-Step 'Commitando o bump e dando push...'
    git -C $root add pubspec.yaml
    git -C $root commit -m "chore: bump para $Version"
    git -C $root push
    if ($LASTEXITCODE -ne 0) { throw "git push falhou (exit $LASTEXITCODE)." }

    Write-Step "Publicando o release $tag..."
    & $gh release create $tag "$apkDst" --repo $repo --title "Bipi $tag" --notes $Notes
    if ($LASTEXITCODE -ne 0) { throw "gh release create falhou (exit $LASTEXITCODE)." }

    Write-Step "Release $tag publicado! O QR do evento ja serve a versao nova."
}
else {
    Write-Step "Pronto para publicar a $tag. Faltam 2 passos no seu terminal autenticado:"
    Write-Host ''
    Write-Host '  1) Commitar e subir o bump:' -ForegroundColor Yellow
    Write-Host "       git add pubspec.yaml; git commit -m `"chore: bump para $Version`"; git push"
    Write-Host ''
    Write-Host '  2) Publicar o release:' -ForegroundColor Yellow
    Write-Host "       $ghCmd"
    Write-Host ''
    Write-Host '  (ou rode de novo com -Publish para fazer os 2 automaticamente)' -ForegroundColor DarkGray
}
