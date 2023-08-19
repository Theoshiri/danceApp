from dance_analyzer import DanceAnalyzer

video_path = 'sample_video/Solo_Salsa_Jordynn_Lurie.mp4'
# video_path = 0
ai_engine = DanceAnalyzer()
ai_engine.process_video(video_path=video_path, save_video=True, show_image=True)
