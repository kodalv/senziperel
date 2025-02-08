#!/bin/bash

# Кількість ітерацій (за замовчуванням 5)
ITERATIONS=${1:-5}

# Категорії файлів для логічних назв
PREFIXES=("script" "server" "client" "config" "auth" "data" "task" "logger" "utility" "process")
SUFFIXES=("handler" "manager" "service" "generator" "module" "config" "parser" "executor" "controller" "loader")

# Доступні розширення файлів
EXTENSIONS=("sh" "py" "js" "txt")

# Функція для генерації осмисленої назви файлу
generate_filename() {
    PREFIX="${PREFIXES[$RANDOM % ${#PREFIXES[@]}]}"
    SUFFIX="${SUFFIXES[$RANDOM % ${#SUFFIXES[@]}]}"
    EXT="${EXTENSIONS[$RANDOM % ${#EXTENSIONS[@]}]}"

    if [[ "$EXT" == "txt" ]]; then
        echo "${PREFIX}_${SUFFIX}_$(openssl rand -hex 2).$EXT"
    else
        echo "${PREFIX}_${SUFFIX}.$EXT"
    fi
}

# Функція для генерації варіативного фейкового коду
generate_fake_code() {
    local FILENAME="$1"
    local EXT="${FILENAME##*.}"
    local VARIANT=$((RANDOM % 3))  # Обираємо один із 3 варіантів коду

    case "$EXT" in
        "sh")
            case "$VARIANT" in
                0) echo -e "#!/bin/bash\n\necho \"Starting process...\"\nsleep 2\necho \"Process complete!\"" ;;
                1) echo -e "#!/bin/bash\n\nfor i in {1..3}; do\n  echo \"Task \$i running\"\n  sleep 1\ndone" ;;
                2) echo -e "#!/bin/bash\n\nwhile true; do\n  echo \"Checking server status...\"\n  sleep 5\ndone" ;;
            esac
            ;;
        "py")
            case "$VARIANT" in
                0) echo -e "#!/usr/bin/env python3\n\ndef factorial(n):\n    return 1 if n == 0 else n * factorial(n-1)\n\nprint(factorial(5))" ;;
                1) echo -e "#!/usr/bin/env python3\n\nimport time\nfor i in range(3):\n    print(f'Processing {i}')\n    time.sleep(1)" ;;
                2) echo -e "#!/usr/bin/env python3\n\ndef greet(name):\n    return f'Hello, {name}!'\n\nprint(greet('User'))" ;;
            esac
            ;;
        "js")
            case "$VARIANT" in
                0) echo -e "const numbers = [1, 2, 3, 4, 5];\nconsole.log(numbers.map(n => n * 2));" ;;
                1) echo -e "function greet(name) {\n  return `Hello, ${name}!`;\n}\nconsole.log(greet('User'));" ;;
                2) echo -e "async function fetchData() {\n  console.log('Fetching data...');\n  await new Promise(r => setTimeout(r, 2000));\n  console.log('Data loaded');\n}\nfetchData();" ;;
            esac
            ;;
        "txt")
            case "$VARIANT" in
                0) echo -e "Project Notes:\n- Refactor codebase\n- Improve performance\n- Update documentation" ;;
                1) echo -e "Bug List:\n1. Fix login issue\n2. Resolve API timeout\n3. Correct UI glitches" ;;
                2) echo -e "Feature Requests:\n- Dark mode support\n- Add multi-language support\n- Improve error handling" ;;
            esac
            ;;
    esac
}

# Запускаємо цикл
for ((i=1; i<=ITERATIONS; i++)); do
    FILENAME=$(generate_filename)

    # Генеруємо контент для файлу
    generate_fake_code "$FILENAME" > "$FILENAME"

    if [[ "$FILENAME" == *.sh || "$FILENAME" == *.py ]]; then
        chmod +x "$FILENAME"
    fi

    git add "$FILENAME"
    git commit -m "Added random script: $FILENAME"

    echo "[$i/$ITERATIONS] Створено і закомічено файл: $FILENAME"
done

# Пушимо всі коміти разом
git push origin main  # Якщо основна гілка "master", заміни "main" на "master"

echo "✅ Успішно створено $ITERATIONS випадкових файлів та запушено в репозиторій!"
