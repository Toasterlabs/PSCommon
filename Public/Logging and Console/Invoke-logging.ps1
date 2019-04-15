Function invoke-logging{
    <#
    .SYNOPSIS
        Helper function to write colored output to the console, and add it to a log file if desired
    
    .DESCRIPTION
        This is a helper script to write colored output to the console, without using write-host. We rely on Invoke-ColorOutput to write the message to the console and then write it to a log file if the runlog parameter is specified.
    
    .PARAMETER Message
        Required Parameter
        Type STRING

        The text to use in the message. This will get modified (unless log level is TEXT or TITLE) to add the time and status in front of it.
        
    .PARAMETER LogLevel
        Required Parameter
        Type STRING

        Defines in what sort of level we should attribute to it.

    .PARAMETER RunLog
        Not a required Parameter
        Type System.IO.FileInfo

        When specified, the function will attempt to output the message to the log file specified here.
        Will be validated to ensure it's not NULL or EMPTY
    
    .INPUTS
        A Message
    
    .OUTPUTS
        Log file as specified
        Console text
    
    .NOTES
        Version:        1.0
        Author:         Marc Dekeyser
        Creation Date:  April 15th, 2019
        Purpose/Change: Initial script development
    
    .EXAMPLE
        Invoke-logging -Message 'Just a test message' -LogLevel 'INFO'

    .EXAMPLE
        Invoke-logging -Message 'Just a test message' -LogLevel 'INFO' -Runlog C:\Temp\Testlog.log

    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,Position=1,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        [STRING[]]$Message,
        [Parameter(Mandatory=$True)]
		[Validateset('STATUS','INFO','SUCCESS','AUDIT','TITLE','TEXT')]
        [STRING]$LogLevel,
        [Parameter(Mandatory=$False)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]$RunLog
    )
    Begin{
        # Catching non-terminating errors
        Write-Verbose -Message "Setting ErrorActionPreference to catch non-terminating errors."
        $ErrorActionPreference = 'Stop'
        
        # Checking if invoke-coloroutput exists (you know, these 2 are part of the PSCommon module, but you never know what happens...)
        Try{
            get-command Invoke-ColorOutput -commandType Cmdlet 
        }Catch{
            Write-warning -Message "Invoke-ColorOutput does not exist. Unable to continue..."
            Break
        }

        # Defining color codes
        Write-Verbose -Message 'Defining colors'
        $StatusColor  = 'Magenta'
        $InfoColor    = 'White'
        $SuccessColor = 'Green' 
        $AuditColor   = 'DarkGrey'
        $TitleColor   = 'Green'
        $TextColor    = 'White'

        # Message formatting (do not apply if the loglevel is TEXT or TITLE)
        If(($LogLevel -ne 'TEXT') -and ($LogLevel -ne 'TITLE')){
            write-verbose -Message 'Formatting content'
            $Message = (get-date -Format HH:mm:ss) + ' - [' + $LogLevel + ']: ' + $Message    
        }
        
    }
    Process{
        Try{
            # Switching actions based on loglevel
            Switch($LogLevel){
                'STATUS'    {
                                Invoke-ColorOutput $Message -ForegroundColor $StatusColor
                                If($RunLog){
                                    Write-Verbose -Message 'Adding content to log file'
                                    $Message | Out-File $RunLog -Append
                                }
                            }
                'INFO'      {
                                Invoke-ColorOutput $Message -ForegroundColor $InfoColor
                                If($RunLog){
                                    Write-Verbose -Message 'Adding content to log file'
                                    $Message | Out-File $RunLog -Append
                                }
                            }
                'SUCCESS'   {
                                Invoke-ColorOutput $Message -ForegroundColor $SuccessColor
                                If($RunLog){
                                    Write-Verbose -Message 'Adding content to log file'
                                    $Message | Out-File $RunLog -Append
                                }
                            }
                'SUCCESS'   {
                                Invoke-ColorOutput $Message -ForegroundColor $AuditColor
                                If($RunLog){
                                    Write-Verbose -Message 'Adding content to log file'
                                    $Message | Out-File $RunLog -Append
                                }
                            }
                'TITLE'     {
                                Invoke-ColorOutput $Message -ForegroundColor $TitleColor
                                If($RunLog){
                                    Write-Verbose -Message 'Adding content to log file'
                                    $Message | Out-File $RunLog -Append
                                }
                            }
                'TEXT'   {
                                Invoke-ColorOutput $Message -ForegroundColor $TextColor
                                If($RunLog){
                                    Write-Verbose -Message 'Adding content to log file'
                                    $Message | Out-File $RunLog -Append
                                }
                            }
            }
        }Catch [System.UnauthorizedAccessException]{
            Write-Warning -Message 'No permission to access that file!'
        }Catch [System.IO.DirectoryNotFoundException]{
            Write-Warning -Message 'The directory you specified does not exist...'
        }Catch{
            Write-warning -Message "Oops... We encountered an unexpected error adding the content to the logfile: $($_.Exception.GetType().FullName)"
        }
    }End{
        # Setting error action preference to default
        $ErrorActionPreference = 'Continue'
    }
}