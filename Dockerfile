# --- ЭТАП 1: Сборка проекта (Builder) ---
    FROM node:20-alpine AS builder
    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    RUN npm run build
    
    
    # --- ЭТАП 2: Финальный образ (Runner) ---
    FROM node:20-alpine
    WORKDIR /app
    
    # Копируем зависимости
    COPY package*.json ./
    
    # Устанавливаем ТОЛЬКО production-зависимости, если это возможно.
    # Но так как astro - это dev-зависимость, нам нужно установить все.
    RUN npm install
    
    # ▼▼▼ КЛЮЧЕВОЕ ИЗМЕНЕНИЕ ▼▼▼
    # Копируем конфигурацию Astro, чтобы preview-сервер ее увидел!
    COPY --from=builder /app/astro.config.mjs ./
    
    # Копируем папку public, если она есть (для логотипов и т.д.)
    COPY --from=builder /app/public ./public
    
    # Копируем уже собранный сайт
    COPY --from=builder /app/dist ./dist
    
    EXPOSE 4321
    
    # Запускаем preview-сервер, который теперь найдет конфиг
    CMD ["npm", "run", "preview"]