# Google Groups Security Check PowerShell Script

## Overview
This PowerShell script (`google_groups_security_check.ps1`) is designed to audit and secure Google Groups by identifying groups with public conversation visibility and automatically changing their settings to private. The script ensures that only group members can view group conversations, enhancing organizational security.

## Features
- ✅ Scans all Google Groups in your organization
- 🔍 Identifies groups with public conversation visibility
- 🔒 Automatically changes public groups to private settings
- 📊 Generates detailed CSV reports
- 📝 Provides comprehensive logging with color-coded output
- ⚡ Progress tracking during execution

## Prerequisites
- **PowerShell 5.1 or later**
- **GAM (Google Admin Management)** tool installed and configured
- **Google Workspace Admin privileges** to modify group settings
- Proper authentication with Google Workspace APIs

## GAM Installation
If you don't have GAM installed, visit: https://github.com/taers232c/GAMADV-XTD3

## Usage

### Basic Execution
```powershell
.\google_groups_security_check.ps1
```

### What the Script Does

1. **Discovery Phase**
   - Retrieves all Google Groups using `gam print groups`
   - Creates a temporary CSV file for processing

2. **Analysis Phase**
   - Checks each group's `whoCanViewGroup` setting
   - Identifies groups with these public settings:
     - `ANYONE_CAN_VIEW` - Anyone on the web can view
     - `ALL_IN_DOMAIN_CAN_VIEW` - Anyone in the domain can view

3. **Remediation Phase**
   - Changes identified public groups to `ALL_MEMBERS_CAN_VIEW`
   - Only group members can view conversations

4. **Reporting Phase**
   - Generates timestamped CSV reports
   - Displays results in console with color coding

## Output Files

The script generates two CSV files with timestamps:

### 1. Public Groups Report
- **Filename**: `public_groups_YYYYMMDD_HHMMSS.csv`
- **Contents**: All groups found with public visibility settings
- **Columns**:
  - `GroupEmail`: Group email address
  - `GroupName`: Display name of the group
  - `WhoCanViewGroup`: Current visibility setting
  - `Description`: Group description

### 2. Changed Groups Report
- **Filename**: `groups_changed_to_private_YYYYMMDD_HHMMSS.csv`
- **Contents**: Groups successfully updated to private settings
- **Columns**: Same as above

## Console Output

The script provides real-time feedback with color-coded messages:
- 🟢 **Green**: Success messages and progress updates
- 🟡 **Yellow**: Current group being processed
- 🔴 **Red**: Warnings about public groups found
- ⚠️ **Warning**: Errors during processing

## Security Benefits

- **Data Protection**: Prevents unauthorized access to group conversations
- **Compliance**: Helps meet organizational security policies
- **Audit Trail**: Provides detailed reports for security reviews
- **Automated Remediation**: Reduces manual effort in securing groups

## Error Handling

- Graceful handling of inaccessible or problematic groups
- Detailed error messages for troubleshooting
- Continues processing even if individual groups fail
- Automatic cleanup of temporary files

## Best Practices

1. **Test First**: Run the script in a test environment before production
2. **Backup**: Consider backing up current group settings before running
3. **Schedule**: Consider running periodically to catch new public groups
4. **Review Reports**: Always review the generated CSV files
5. **Monitor**: Check for any error messages during execution

## Troubleshooting

### Common Issues
- **GAM not found**: Ensure GAM is installed and in your PATH
- **Authentication errors**: Verify your Google Workspace admin credentials
- **Permission denied**: Ensure you have admin rights to modify group settings

### Log Analysis
Check the console output for:
- Groups that couldn't be processed
- Authentication issues
- Network connectivity problems

## Version Information
- **Author**: Yossi Yosef
- **Version**: 1.2.0
- **Last Updated**: 22/07/2025

## Support
For issues or questions about this script, review the console output and generated CSV files for detailed information about any problems encountered. 
