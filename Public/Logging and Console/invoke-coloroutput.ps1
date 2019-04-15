function Invoke-ColorOutput{
	<#
    .SYNOPSIS
        Helper function to write colored output to the console.
    .DESCRIPTION
        This is a helper script to write colored output to the console, without using write-host. 
    
	.PARAMETER Object
		Aliases: Message, msg
        The text to use in the message. 
        
	.PARAMETER ForegroundColor
		Aliases: Fore, FGR
		The color to be used for the text

	.PARAMETER BackgroundColor
		Aliases: Back, BGR
		The color to be used for the background

	.PARAMETER NoNewLine
		Does not place the text on a new line.

    .NOTES
        Version:        1.0
        Author:         Marc Dekeyser
        Creation Date:  April 15th, 2019
		Purpose/Change: Initial script development
		URI:            https://hornedowl.net/
    
    .EXAMPLE
        Invoke-ColorOutput -Message 'Just a test message' 

    .EXAMPLE
       1..10 | Invoke-ColorOutput -Message 'Just a test message'

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False,Position=1,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
		[alias('message')]
		[alias('msg')]
		[Object[]]$Object,
        [Parameter(Mandatory=$False,Position=2)]
		[ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
        [alias('fore')]
        [alias('FGR')]
		[ConsoleColor] $ForegroundColor,
        [Parameter(Mandatory=$False,Position=3)]
		[ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
		[alias('back')]
		[alias('BGR')]
		[ConsoleColor] $BackgroundColor,
        [Switch]$NoNewline
    )    
	Begin{
		# Save previous colors
		If($ForegroundColor){
			$previousForegroundColor = $host.UI.RawUI.ForegroundColor
		}
		
		If($BackgroundColor){
			$previousBackgroundColor = $host.UI.RawUI.BackgroundColor
		}
		
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
		If($ForegroundColor){
			$host.UI.RawUI.ForegroundColor = $previousForegroundColor
		}
		
		If($BackgroundColor){
			$host.UI.RawUI.BackgroundColor = $previousBackgroundColor
		}
		
	}
}