# --- ЭТАП 1: Сборка проекта ---
    FROM node:20-alpine AS builder
    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    RUN npm run build
    
    # --- ЭТАП 2: Финальный образ ---
    FROM node:20-alpine
    WORKDIR /app
    
    # Копируем зависимости
    COPY package*.json ./
    
    # Устанавливаем ТОЛЬКО production-зависимости, включая наш новый 'host'
    RUN npm install --omit=dev
    
    # Копируем собранный сайт
    COPY --from=builder /app/dist ./dist
    
    # EXPOSE больше не нужен для 'host', но можно оставить для информации
    EXPOSE 3000
    
    # Запускаем наш новый, простой сервер
    CMD ["npm", "run", "preview"]