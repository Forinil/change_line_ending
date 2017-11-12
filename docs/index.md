Ruby script that changes line endings 

### Regular usage ###
**Usage:** `./change_line_ending.rb directory_path desired_line_ending included_regexp(optional) log_dir(optional)`

**Options:**

- `directory_path` - directory with files to be processed
- `desired_line_ending` - line ending files are to be converted to, must be one of `\n`, `\r` or `\r\n`
- `included_regexp` - regular expression specifying which files from `directory_path` are to be processed
- `log_dir` - directory, where application log files are to be stored

If `log_dir` is not specified, program stores log files in directory path stored in `LOG_PATH` environmental variable.
If that variable is not set, log files are being stored in the directory of the script.

If `included_regexp` is not specified, all non-binary files form directory_path directory are proceseed.

**Warning:** script qualifies whether file is binary or not using ptools library, which is known to make mistakes,
so if `directory_path` contains binary files it's best to specify `included_regexp` to avoid accidentally processing them.

### Docker usage ###

#### With git repository ####
```bash
git clone https://github.com/Forinil/change_line_ending.git
cd change_line_ending
docker build -t change_line_ending .
docker run -it --rm  -v directory_path:/files change_line_ending /files desired_line_ending included_regexp(optional) log_dir(optional)
```

#### With docker repository ####
[Docker Hub repository](https://hub.docker.com/r/forinil/change_line_ending/)
```bash
docker pull forinil/change_line_ending
docker tag forinil/change_line_ending change_line_ending
docker run -it --rm  -v directory_path:/files change_line_ending /files desired_line_ending included_regexp(optional) log_dir(optional)
```

Of course there is no need to tag docker repository image with shorter name before using it, it is simply 
more convenient for repeated use.

If you want to access application log files after running docker image, you must mount a host directory to one inside the container 
and point the application to it by either specifying `log_dir` parameter or `LOG_PATH` variable (especially if you wish to avoid specifying
regular expression as well).

For example:
```bash
docker run -it --rm -v directory_path:/files -v `$(pwd)`:/logs -e LOG_PATH=/logs change_line_ending /files desired_line_ending
```