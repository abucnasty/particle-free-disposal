try {
	$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
	if (-not $scriptDir) { $scriptDir = (Get-Location).Path }

	$modPath = Join-Path $scriptDir 'mod'

	$zipName = 'particle_free_disposal_batch_0.1.0.zip'
	$zipPath = Join-Path $scriptDir $zipName

	$tempBase = Join-Path $env:TEMP ("particle_free_disposal_batch_tmp_" + [guid]::NewGuid().ToString())
	New-Item -ItemType Directory -Path $tempBase | Out-Null
	$renamedDir = Join-Path $tempBase 'particle_free_disposal_batch'
	New-Item -ItemType Directory -Path $renamedDir | Out-Null

	Copy-Item -Path (Join-Path $modPath '*') -Destination $renamedDir -Recurse -Force

	if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

	Compress-Archive -Path $renamedDir -DestinationPath $zipPath -Force

	Write-Host "Created zip: $zipPath"
	$exitCode = 0
} catch {
	Write-Error "Failed to create zip: $_"
	$exitCode = 2
} finally {
	# Cleanup temp workspace
	if ($tempBase -and (Test-Path $tempBase)) {
		try { Remove-Item -Path $tempBase -Recurse -Force -ErrorAction SilentlyContinue } catch {}
	}
}

exit $exitCode
