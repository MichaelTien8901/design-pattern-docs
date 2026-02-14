FROM gcc:latest

RUN apt-get update && apt-get install -y cmake && rm -rf /var/lib/apt/lists/*

WORKDIR /app

CMD ["bash", "run_all.sh"]
