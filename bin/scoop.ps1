#requires -v 3
param($cmd)

set-strictmode -off

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\git.ps1"
. "$psscriptroot\..\lib\buckets.ps1"
. (relpath '..\lib\commands')

reset_aliases

$commands = commands
if ('--version' -contains $cmd -or (!$cmd -and '-v' -contains $args)) {
    Push-Location $(versiondir 'scoop' 'current')
    write-host "Current Scoop version:"
    git_log --oneline HEAD -n 1
    write-host ""
    Pop-Location

    buckets | ForEach-Object {
        Push-Location $(bucketdir $_)
        if(test-path '.git') {
            write-host "'$_' bucket:"
            git_log --oneline HEAD -n 1
            write-host ""
        }
        Pop-Location
    }
}
elseif (@($null, '--help', '/?') -contains $cmd -or $args -contains '-h') { exec 'help' $args }
elseif ($commands -contains $cmd) { exec $cmd $args }
else { "scoop: '$cmd' isn't a scoop command. See 'scoop help'."; exit 1 }
