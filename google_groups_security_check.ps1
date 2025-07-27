
# ----------------------------------------------------------------------------------------------------------------
# explanation:
# This script checks all groups for public conversation visibility
# and change the group settings to private (only group members can view)
# Script created by: Yossi Yosef 
# Last updated: 22/07/2025
# Version: 1.2.0
# ---------------------------------------------------------------------------------------------------------------- 

# Get all groups and export to temporary CSV file
Write-Host "Getting all groups..." -ForegroundColor Green
gam print groups > groups_temp.csv

# Read the groups CSV file
$groups = Import-Csv groups_temp.csv

# Initialize array to store results in $publicGroups variable
$publicGroups = @()

# Counter for progress
$counter = 0
$total = $groups.Count

Write-Host "Checking $total groups for public conversation visibility..." -ForegroundColor Green

foreach ($group in $groups) {
    $counter++
    $groupEmail = $group.email
    Write-Host "Checking group: $groupEmail" -ForegroundColor Yellow
    
    try {
        # Get group settings - redirect stderr to null to avoid cluttering output
        $groupSettings = gam info group $groupEmail | select-string "whoCanViewGroup:"
        
        # Check if the group allows anyone on the web to view conversations
        $whoCanViewGroup = ($groupSettings | Select-String "whoCanViewGroup").ToString()
        
        # Check for public visibility settings
        if ($whoCanViewGroup -match "ANYONE_CAN_VIEW" -or $whoCanViewGroup -match "ALL_IN_DOMAIN_CAN_VIEW") {
            $publicGroups += [PSCustomObject]@{
                GroupEmail = $groupEmail
                GroupName = $group.name
                WhoCanViewGroup = $whoCanViewGroup.Split(':')[1].Trim()
                Description = $group.description
            }
            
            Write-Host "Warning: Found public group: $groupEmail" -ForegroundColor Red
        }
    }
    catch {
        Write-Warning "Error checking group $groupEmail : $_"
    }
}

# Clean up temporary file
Remove-Item groups_temp.csv -ErrorAction SilentlyContinue

# Display results
Write-Host "`nGroups with public conversation visibility:" -ForegroundColor Red
if ($publicGroups.Count -gt 0) {
    $publicGroups | Format-Table -AutoSize
    
    # Generate timestamp for filename
    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $csvFileName = "public_groups_$timestamp.csv"
    
    # Export results to CSV
    $publicGroups | Export-Csv -Path $csvFileName -NoTypeInformation
    Write-Host "Results exported to $csvFileName" -ForegroundColor Green
    
    # sleep 3 seconds
    Start-Sleep -Seconds 3

    # Change group settings to private
    Write-Host "`nChanging group settings to private..." -ForegroundColor Green
    
    # Initialize array to store successfully changed groups
    $changedGroups = @()
    
    foreach ($group in $publicGroups) {
        try {
            Write-Host "Updating group: $($group.GroupEmail)" -ForegroundColor Yellow
            gam update group $group.GroupEmail whoCanViewGroup ALL_MEMBERS_CAN_VIEW
            Write-Host "Successfully updated: $($group.GroupEmail)" -ForegroundColor Green
            
            # Add to changed groups list
            $changedGroups += $group
        }
        catch {
            Write-Warning "Error updating group $($group.GroupEmail): $_"
        }
    }
    
    # Display and export changed groups
    if ($changedGroups.Count -gt 0) {
        Write-Host "`nGroups that were changed to private:" -ForegroundColor Green
        $changedGroups | Select-Object -Property GroupEmail, GroupName, WhoCanViewGroup, Description | Format-Table -AutoSize
        
        # Export changed groups to separate CSV file
        $changedCsvFileName = "groups_changed_to_private_$timestamp.csv"
        $changedGroups | Export-Csv -Path $changedCsvFileName -NoTypeInformation
        Write-Host "Changed groups exported to $changedCsvFileName" -ForegroundColor Green
        
        Write-Host "Groups settings changed to private. Total groups updated: $($changedGroups.Count)" -ForegroundColor Green
    } else {
        Write-Host "No groups were successfully updated." -ForegroundColor Red
    }
} else {
    Write-Host "No groups found with public conversation visibility." -ForegroundColor Green
}

Write-Host "`nScript completed. Total groups checked: $total" -ForegroundColor Green
