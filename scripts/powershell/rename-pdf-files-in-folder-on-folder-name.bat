get-childitem -path "D:\" | foreach -process {
	Get-ChildItem -path $_.FullName | foreach -process {
		if ($_.Extension -eq ".pdf") {
			rename-item $_.FullName $("{0}\{1}{2}" -f $_.directory,$_.directory.name,$_.extension)
		}
	}
}
