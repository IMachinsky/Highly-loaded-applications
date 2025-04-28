from flask import Flask, jsonify, render_template, request
import os
import redis
import time

app = Flask(__name__)

# Подключение к Redis
redis_client = redis.StrictRedis(host='redis', port=6379, decode_responses=True)

# Уникальный идентификатор из переменной окружения
INSTANCE_ID = os.getenv("INSTANCE_ID", "Unknown Instance")

@app.route('/counter', methods=['GET'])
def get_counter():
    # Увеличиваем счетчик в Redis
    redis_client.incr('global_counter')
    counter = redis_client.get('global_counter')
    return jsonify({"counter": str(counter), "instance": INSTANCE_ID})

@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')


@app.route('/leaderboard/<player>', methods=['POST'])
def add_to_leaderboard(player):
    # Получаем текущий счетчик из Redis
    score = redis_client.incr('global_counter')

    # Добавляем игрока в отсортированное множество
    redis_client.zadd('leaderboard', {player: score})

    return jsonify({"message": f"Player {player} added with score {score}"}), 201


@app.route('/leaderboard', methods=['GET'])
def get_leaderboard():
    # Получаем топ-N игроков из отсортированного множества
    top_players = redis_client.zrevrange('leaderboard', 0, -1, withscores=True)

    # Формируем список лидеров
    leaderboard = [{"player": player, "score": int(score)} for player, score in top_players]

    return jsonify(leaderboard)


@app.route('/enqueue', methods=['POST'])
def enqueue():
    # Получаем сообщение из запроса
    message = request.json.get('message')
    if not message:
        return jsonify({"error": "Message is required"}), 400

    # Добавляем сообщение в очередь Redis
    redis_client.lpush('task_queue', message)
    return jsonify({"status": "success", "message": message})


@app.route('/process', methods=['GET'])
def process():
    # Получаем сообщение из очереди Redis
    message = redis_client.rpop('task_queue')
    if not message:
        return jsonify({"status": "empty", "message": "No messages in the queue"})

    # Имитация обработки с задержкой
    time.sleep(2)
    return jsonify({"status": "success", "processed_message": message})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)


