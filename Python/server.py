from flask import Flask, request, jsonify

from dance_analyzer import DanceAnalyzer
from utils_func import remove_file

app = Flask(__name__)
ai_dance = DanceAnalyzer()


@app.route("/")
def home():
    return "<h1>Animal Pose Analyzer</h1>"


@app.route('/analyze_dance', methods=['POST'])
def fetch_pose():
    if request.method == 'POST':
        f = request.files['video']
        filename = f.filename
        f.save(filename)
        url = ai_dance.process_video(video_path=filename, save_video=True)
        # print(url)
        remove_file(filename)
        return jsonify(url)


app.run(host='0.0.0.0')
