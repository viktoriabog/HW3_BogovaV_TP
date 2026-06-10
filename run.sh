#!/bin/bash
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
case "$1" in
  build_generator)
    echo ">>> Сборка образа generator..."
    docker build -t generator "$PROJECT_DIR/generator"
    ;;
  run_generator)
    echo ">>> Запуск генератора (результат → data/data.csv)..."
    mkdir -p "$PROJECT_DIR/data"
    docker run --rm \
      -v "$PROJECT_DIR/data:/data" \
      generator
    echo ">>> Готово! Файл: $PROJECT_DIR/data/data.csv"
    ;;

  create_local_data)
    echo ">>> Создание data.csv локально (без Docker) в папке local_data/..."
    mkdir -p "$PROJECT_DIR/local_data"
    python3 "$PROJECT_DIR/generator/generate.py" "$PROJECT_DIR/local_data"
    echo ">>> Готово! Файл: $PROJECT_DIR/local_data/data.csv"
    ;;

  build_reporter)
    echo ">>> Сборка образа reporter..."
    docker build -t reporter "$PROJECT_DIR/reporter"
    ;;

  run_reporter)
    echo ">>> Запуск аналитика (результат → data/report.html)..."
    mkdir -p "$PROJECT_DIR/data"
    docker run --rm \
      -v "$PROJECT_DIR/data:/data" \
      reporter
    echo ">>> Готово! Файл: $PROJECT_DIR/data/report.html"
    ;;
  structure)
    echo ">>> Структура проекта:"
    find "$PROJECT_DIR" -not -path '*/.git/*' -not -name '.DS_Store' \
      | sort \
      | sed "s|$PROJECT_DIR/||" \
      | sed 's|[^/]*/|  |g'
    ;;

  clear_data)
    echo ">>> Удаление сгенерированных файлов из data/..."
    rm -f "$PROJECT_DIR/data/"*.csv "$PROJECT_DIR/data/"*.html
    echo ">>> Папка data/ очищена."
    ;;

  inside_generator)
    echo ">>> Запуск генератора и просмотр /data изнутри контейнера..."
    mkdir -p "$PROJECT_DIR/data"
    docker run --rm \
      -v "$PROJECT_DIR/data:/data" \
      --entrypoint sh \
      generator \
      -c "ls -la /data"
    ;;

  inside_reporter)
    echo ">>> Запуск репортера и просмотр /data изнутри контейнера..."
    mkdir -p "$PROJECT_DIR/data"
    docker run --rm \
      -v "$PROJECT_DIR/data:/data" \
      --entrypoint sh \
      reporter \
      -c "ls -la /data"
    ;;

  *)
    echo "Использование: ./run.sh <команда>"
    echo "Доступные команды:"
    echo "  build_generator    — собрать образ генератора"
    echo "  run_generator      — запустить генератор, создаёт data/data.csv"
    echo "  create_local_data  — создать data.csv локально (без Docker) в local_data/"
    echo "  build_reporter     — собрать образ аналитика"
    echo "  run_reporter       — запустить аналитик, создаёт data/report.html"
    echo "  structure          — вывести структуру файлов проекта"
    echo "  clear_data         — удалить .csv и .html из папки data/"
    echo "  inside_generator   — показать /data изнутри контейнера генератора"
    echo "  inside_reporter    — показать /data изнутри контейнера аналитика"
    ;;
esac
