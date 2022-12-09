/* firmware version and date */
_version_major = @VERSION_MAJOR@;
_version_minor = @VERSION_MINOR@;
_subversion = @SUBVERSION@;

_date = @DATE@;
_time = @TIME@;

_git_size = @GIT_COMMIT_LEN@;

TARGET(binary) /* specify the file format of binary file */
INPUT ("@GIT_COMIT_FILE@") /* include the file */
OUTPUT_FORMAT(default) /* restore the out file format */
