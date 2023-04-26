# Validates an actions version string, checking that it is a semantic release version and that it hasn't been released yet.

SEMANTIC_VERSION_REGEX = /^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/

# Parse the new version string from the arguments
abort "Missing argument. Requires: version string." unless ARGV.count == 1
new_version = ARGV[0]

# Validate the version string
abort "Validation failed: #{version} is not a semantic release version." unless new_version.match?(SEMANTIC_VERSION_REGEX)

# Check if a tag for that version already exists in the remote
# This command:
# 1. Fetches all tags from origin
# 2. Lists all tags that match the new version string
# 3. Returns the new version string if the corresponding tag was found, empty string otherwise
version_tag_check = %x( git fetch origin --tags --prune --prune-tags --force && git tag -l "#{new_version}" | head -1)

# Fail if the tag was found
abort "Validation failed: #{new_version} tag already exists on the remote." unless version_tag_check.empty?
