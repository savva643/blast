<?php
require "db.php";
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Скачать blast!</title>
    <link rel="preconnect" href="http://fonts.googleapis.com">
    <link rel="preconnect" href="http://fonts.gstatic.com" crossorigin>
    <link href="http://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: "Montserrat", sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(0deg, rgb(105 0 123), #120033);
            color: white;
            min-height: 100vh;
        }
        
        .top-bar {
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .top-bar-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        
        .logo {
            font-size: 1.8rem;
            font-weight: 900;
            color: white;
            text-decoration: none;
            text-transform: lowercase;
        }
        
        .nav-links {
            display: flex;
            gap: 30px;
            align-items: center;
        }
        
        .nav-link {
            color: white;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.3s ease;
            opacity: 0.8;
        }
        
        .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            opacity: 1;
        }
        
        .nav-link.active {
            background: rgba(92, 0, 255, 0.8);
            opacity: 1;
        }
        
        @media (max-width: 768px) {
            .nav-links {
                gap: 15px;
            }
            
            .nav-link {
                font-size: 0.9rem;
                padding: 6px 12px;
            }
            
            .logo {
                font-size: 1.5rem;
            }
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            padding: 60px 0;
        }
        
        .header h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-transform: lowercase;
        }
        
        .header p {
            font-size: 1.2rem;
            opacity: 0.8;
            margin-bottom: 40px;
        }
        
        .platforms {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin: 60px 0;
        }
        
        .platform-category {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .platform-category h2 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: #fff;
            text-align: center;
        }
        
        .platform-links {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .download-btn {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 20px;
            background: rgba(92, 0, 255, 0.8);
            border: 2px solid rgba(92, 0, 255, 0.5);
            border-radius: 40px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .download-btn:hover {
            background: rgba(92, 0, 255, 1);
            border-color: rgba(92, 0, 255, 1);
            transform: translateY(-2px);
        }
        
        .download-btn.disabled {
            background: rgba(128, 128, 128, 0.5);
            border-color: rgba(128, 128, 128, 0.3);
            cursor: not-allowed;
            opacity: 0.6;
        }
        
        .download-btn.disabled:hover {
            transform: none;
        }
        
        .platform-icon {
            font-size: 1.2rem;
            margin-right: 10px;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2.5rem;
            }
            
            .platforms {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .platform-category {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="top-bar">
        <div class="top-bar-content">
            <a href="blast.php" class="logo">blast!</a>
            <nav class="nav-links">
                <a href="blast.php" class="nav-link">Главная</a>
                <a href="download.php" class="nav-link active">Скачать</a>
                <a href="about.php" class="nav-link">О Blast</a>
                <a href="changelog.php" class="nav-link">Обновления</a>
            </nav>
        </div>
    </div>

    <div class="container">
        <div class="header">
            <h1>blast!</h1>
            <p>Скачайте blast! для вашего устройства</p>
        </div>
        
        <div class="platforms">
            <!-- PC Platforms -->
            <div class="platform-category">
                <h2>💻 Компьютеры</h2>
                <div class="platform-links">
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">🪟</span>Windows</span>
                        <span>Скоро</span>
                    </a>
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">🍎</span>macOS</span>
                        <span>Скоро</span>
                    </a>
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">🐧</span>Linux</span>
                        <span>Скоро</span>
                    </a>
                </div>
            </div>
            
            <!-- Mobile Platforms -->
            <div class="platform-category">
                <h2>📱 Мобильные устройства</h2>
                <div class="platform-links">
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">🤖</span>Android</span>
                        <span>Скоро</span>
                    </a>
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">📱</span>iOS</span>
                        <span>Скоро</span>
                    </a>
                </div>
            </div>
            
            <!-- TV Platforms -->
            <div class="platform-category">
                <h2>📺 Телевизоры и ТВ-приставки</h2>
                <div class="platform-links">
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">📺</span>Android TV</span>
                        <span>Скоро</span>
                    </a>
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">🍎</span>Apple TV</span>
                        <span>Скоро</span>
                    </a>
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">🌐</span>WebOS (LG)</span>
                        <span>Скоро</span>
                    </a>
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">📱</span>Tizen OS (Samsung)</span>
                        <span>Скоро</span>
                    </a>
                    <a href="#" class="download-btn disabled">
                        <span><span class="platform-icon">🎬</span>Chromecast</span>
                        <span>Скоро</span>
                    </a>
                </div>
            </div>
            
            <!-- Web Version -->
            <div class="platform-category">
                <h2>🌐 Веб-версия</h2>
                <div class="platform-links">
                    <a href="https://blast.keep-pixel.ru" target="_blank" class="download-btn">
                        <span><span class="platform-icon">🌐</span>Открыть в браузере</span>
                        <span>Доступно</span>
                    </a>
                </div>
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 60px; opacity: 0.7;">
            <p>Приложения для других платформ находятся в разработке</p>
            <p>Следите за обновлениями в <a href="changelog.php" style="color: #fff; text-decoration: underline;">истории изменений</a></p>
        </div>
    </div>
</body>
</html>
