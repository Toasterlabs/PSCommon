function Invoke-ColorOutput{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False,Position=1,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
		[alias('message')]
		[alias('msg')]
		[Object[]]$Object,
        [Parameter(Mandatory=$False,Position=2,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
		[ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
        [alias('fore')]
        [alias('FGR')]
		[ConsoleColor] $ForegroundColor,
        [Parameter(Mandatory=$False,Position=3,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
		[ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
		[alias('back')]
		[alias('BGR')]
		[ConsoleColor] $BackgroundColor,
        [Switch]$NoNewline
    )    
	Begin{
		# Save previous colors
		$previousForegroundColor = $host.UI.RawUI.ForegroundColor
		$previousBackgroundColor = $host.UI.RawUI.BackgroundColor
	}Process{
		
		Try{
			# Catching non-terminating errors
			$ErrorActionPreference = 'Stop'
			Foreach($I in $object){
				# Set BackgroundColor if available
				if($BackgroundColor -ne $null){ 
				   $host.UI.RawUI.BackgroundColor = $BackgroundColor
				}

				# Set $ForegroundColor if available
				if($ForegroundColor -ne $null){
					$host.UI.RawUI.ForegroundColor = $ForegroundColor
				}

				# Always write (if we want just a NewLine)
				if($Object -eq $null){
					$Object = ""
				}

				# Writ to Console
				if($NoNewline){
					[Console]::Write($Object)
				}else{
					Write-Output $Object
				}
			}
		}Catch{
			Write-Warning "Oops... Something went wrong! ($($Error[0].Exception.GetType().FullName))"
			
		}Finally{
			# restoring error action preference
			$ErrorActionPreference = 'Continue'
		}
	}End{
		 # Restore previous colors
		$host.UI.RawUI.ForegroundColor = $previousForegroundColor
		$host.UI.RawUI.BackgroundColor = $previousBackgroundColor
	}
}