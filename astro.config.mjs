import { defineConfig } from 'astro/config';
import vue from '@astrojs/vue';

export default defineConfig({
  integrations: [vue()],
  trailingSlash: 'always',

  allowedHosts: ['gtunnel.ru', 'www.gtunnel.ru'],
  i18n: {
    trailingSlash: 'always',
    defaultLocale: "en",
    locales: ["en", "ru"],
    routing: {
      prefixDefaultLocale: true,
    }
  }
});