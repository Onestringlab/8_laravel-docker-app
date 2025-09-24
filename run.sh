#!/bin/bash
# run.sh

# Function untuk menjalankan container
start_containers() {
    echo "🚀 Starting Laravel Docker containers..."
    
    # Build dan jalankan container
    docker compose up -d --build
    
    echo "⏳ Waiting for containers to be ready..."
    sleep 10
    
    # Jalankan migrasi database
    echo "📊 Running database migrations..."
    docker compose exec laravel php artisan migrate --force
    
    echo "✅ Containers are ready!"
    echo "🌐 Application is available at: http://localhost"
    echo "🗄️  Database is available at: localhost:5432"
}

# Function untuk menghentikan container
stop_containers() {
    echo "⏹️  Stopping containers..."
    docker compose down
}

# Function untuk melihat logs
show_logs() {
    docker compose logs -f
}

# Function untuk masuk ke container Laravel
enter_laravel() {
    docker compose exec laravel bash
}

# Function untuk menjalankan Artisan command
artisan() {
    docker compose exec laravel php artisan "$@"
}

# Function untuk menjalankan Composer
composer_cmd() {
    docker compose exec laravel composer "$@"
}

# Menu
case "$1" in
    start)
        start_containers
        ;;
    stop)
        stop_containers
        ;;
    logs)
        show_logs
        ;;
    shell)
        enter_laravel
        ;;
    artisan)
        shift
        artisan "$@"
        ;;
    composer)
        shift
        composer_cmd "$@"
        ;;
    *)
        echo "Usage: $0 {start|stop|logs|shell|artisan|composer}"
        echo ""
        echo "Commands:"
        echo "  start     - Build and start containers"
        echo "  stop      - Stop containers"
        echo "  logs      - Show container logs"
        echo "  shell     - Enter Laravel container"
        echo "  artisan   - Run Artisan commands"
        echo "  composer  - Run Composer commands"
        echo ""
        echo "Examples:"
        echo "  $0 start"
        echo "  $0 artisan migrate"
        echo "  $0 composer install"
        exit 1
        ;;
esac