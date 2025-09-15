# --- ЭТАП 1: Установка зависимостей ---
    FROM node:20-alpine AS deps

    WORKDIR /app
    
    # Копируем только package.json и lock-файл
    COPY package*.json ./
    
    # Устанавливаем ВСЕ зависимости, включая devDependencies для сборки
    RUN npm install
    
    
    # --- ЭТАП 2: Сборка проекта ---
    FROM node:20-alpine AS builder
    
    WORKDIR /app
    
    # Копируем зависимости из предыдущего этапа (это быстро)
    COPY --from=deps /app/node_modules ./node_modules
    
    # А ТЕПЕРЬ копируем ВЕСЬ код проекта
    COPY . .
    
    # Собираем сайт. Astro - это dev-зависимость, поэтому node_modules из deps нам подходит.
    RUN npm run build
    
    
    # --- ЭТАП 3: Финальный образ ---
    FROM node:20-alpine AS runner
    
    WORKDIR /app
    
    # Копируем package.json и lock-файл снова
    COPY package*.json ./
    
    # Устанавливаем ТОЛЬКО production-зависимости, если они есть.
    # В вашем случае их нет, но это лучшая практика. Astro для запуска не нужен.
    # Astro preview - это dev-инструмент, поэтому он останется, если нет prod-зависимостей.
    RUN npm install --omit=dev
    
    # Копируем собранный сайт из этапа сборки
    COPY --from=builder /app/dist ./dist
    
    # Копируем конфигурацию, необходимую для запуска preview
    COPY --from=builder /app/astro.config.mjs ./
    COPY --from=builder /app/package.json ./
    COPY --from=builder /app/tsconfig.json ./
    
    # Копируем папку public
    COPY --from=builder /app/public ./public
    
    EXPOSE 4321
    
    # Запускаем preview-сервер
    CMD ["npm", "run", "preview"]