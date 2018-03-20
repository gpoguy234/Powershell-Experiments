﻿<#
.SYNOPSIS
  Name: script.ps1
  The purpose of this script is to blah blah... What?
  
.DESCRIPTION
  A slightly longer description of example.ps1 Why and How?

.PARAMETER InitialDirectory
  The initial directory which this example script will use.
  
.PARAMETER Add
  A switch parameter that will cause the example function to ADD content.

Add or remove PARAMETERs as required.

.NOTES
    Updated: 2017-01-01        Change comment.
    Release Date: 2017-01-01
   
  Author: YourName

.EXAMPLE
  Run the Get-Example script to create the c:\example folder:
  Get-Example -Directory c:\example

.EXAMPLE 
  Run the Get-Example script to create the folder c:\example and
  overwrite any existing folder in that location:
  Get-Example -Directory c:\example -force

See Help about_Comment_Based_Help for more .Keywords

# Comment-based Help tags were introduced in PS 2.0
#requires -version 2
#>

[CmdletBinding()]

PARAM ( 
    [string]$InitialDirectory = $(throw "-InitialDirectory is required."),
    [switch]$Add = $false
)
#----------------[ Declarations ]------------------------------------------------------

# Set Error Action
# $ErrorActionPreference = "Continue"

# Dot Source any required Function Libraries
# . "C:\Scripts\Functions.ps1"

# Set any initial values
# $Examplefile = "C:\scripts\example.txt"

#----------------[ Functions ]---------------------------------------------------------
Function MyExampleFunction{
  Param()
  
  Begin{
    Write-Host "Start example function..."
  }
  
  Process{
    Try{
      "Do Something here"
    }
    
    Catch{
      "Something went wrong."
      Break
    }

  }
  
  End{
    If($?){ # only execute if the function was successful.
      Write-Host "Completed example function."
    }
  }
}

#----------------[ Main Execution ]----------------------------------------------------

# Script Execution goes here