worker_processes 2
working_directory "/home/anime/startup/current" #appと同じ階層を指定

timeout 3600


listen "/var/run/unicorn/startup.sock"
pid "/var/run/unicorn/startup.pid"


stderr_path "/home/anime/startup/current/log/unicorn.log"
stdout_path "/home/anime/startup/current/log/unicorn.log"


preload_app true