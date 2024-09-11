from dockerfile_parse import DockerfileParser
from pathlib import Path
from subprocess import PIPE, run
from sys import argv, exit


## ---------- FUNCTIONS
# 1. mostrar menu de uso
def usage():
    print(
        """
        DESCRIPTION:
            Utility to facilitate the composition of arguments during docker image builds

        USAGE: 
            docker-build-args [DOCKERFILE_PATH] [DOTENVFILE_PATH]

        EXAMPLES:
            docker-build-args ~/Projects/my-awesome-project/Dockerfile
        """
    )
    exit(0)


# 2. ler entrada do usuario com o caminho de um dockerfile e dotenvfile
def handle_inputs(args):
    if len(args) == 3:
        if args[1] == None or args[1] == "":
            print("Please, provide a Dockerfile path")
            usage()
        elif args[2] == None or args[1] == "":
            print("Please, provide a Dotenvfile path")
            usage()
    else:
        print("Please, provide a Dockerfile path")
        print("Please, provide a Dotenvfile path")
        usage()
    return args[1], args[2]


# 3. validar se os arquivos existem
def check_files(dockerfile_path, dotenvfile_path):
    if not Path(dockerfile_path).exists():
        print(f"Dockerfile not found: {dockerfile_path}")
        usage()

    if not Path(dotenvfile_path).exists():
        print(f"Dotenvfile not found: {dotenvfile_path}")
        usage()


# 4. coletar lista de args do dockerfile e do dotenvfile
def get_original_args(dockerfile_path, dotenvfile_path):
    def get_dockerfile_args():
        if Path("/tmp/docker-build-args").exists():
            Path("/tmp/docker-build-args").rmdir()
        Path("/tmp/docker-build-args").mkdir(parents=True, exist_ok=True)

        dfp = DockerfileParser()
        with open(dockerfile_path, 'r') as f:
            dfp.content = f.read()

        dockerfile_args = []
        for instruction in dfp.structure:
            if instruction["instruction"] == "ARG":
                key = instruction['instruction']
                values = instruction['value'].split()
                for value in values:
                    dockerfile_args.append(value)

        return dockerfile_args

    def get_dotenvfile_args():
        dotenvfile_content = open(dotenvfile_path).readlines()
        dotenvfile_args = []
        for line in dotenvfile_content:
            line = line.removesuffix("\n")
            if not line.startswith("#") and line != "\n" and line != "":
                line_key = line.split("=", maxsplit=1)[0]
                line_value = "".join(line.split("=", maxsplit=1)[1:])
                
                if line_value.replace("'", "").replace('"', '').isdigit():
                    line_value = line_value.replace("'", "").replace('"', '')
                    line = line_key + "=" + line_value
                dotenvfile_args.append([line_key,line_value])
        return dotenvfile_args

    dotenvfile_args = get_dotenvfile_args()
    dockerfile_args = get_dockerfile_args()

    return dockerfile_args, dotenvfile_args


# 5. compilar valores do dotenvfile
def compile_dotenvfile_values(args):
    dotenvfile_args = []
    for env in args:
        env_key = env[0]
        env_val = env[1]

        if env_val.startswith("$"):
            env_val = env_val[2:-1]
            output = run(env_val, shell=True, stdout=PIPE, check=True).stdout.decode('utf-8').strip()
            dotenvfile_args.append(f'{env_key}={output}')
        else:
            dotenvfile_args.append(f'{env_key}={env_val}')

    return dotenvfile_args


## ---------- MAIN
if __name__ == "__main__":
    handle_inputs(argv)
    dockerfile_path = argv[1]
    dotenvfile_path = argv[2]

    check_files(dockerfile_path, dotenvfile_path)
    dockerfile_args, tmp_dotenvfile_args = get_original_args(dockerfile_path, dotenvfile_path)
    dotenvfile_args = compile_dotenvfile_values(tmp_dotenvfile_args)

    dockerfile_args_count = len(dockerfile_args)
    dotenvfile_arg_count = len(dotenvfile_args)

    if dockerfile_args_count != dotenvfile_arg_count:
        print(f"Different amount of arguments between dockerfile({dockerfile_args_count}) and dotenvfile({dotenvfile_arg_count})")
        exit(1)

    for arg in sorted(dotenvfile_args):
        print(arg)
