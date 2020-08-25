# Advert Messages

## Описание
Информационные сообщения в чате

## Требования
AmxModX 1.9.0 или выше

## Настройка
### Список сообщений
`amxmodx/configs/plugins/AdvertMessages/Messages.json`

```json
[
    "Рекламное сообщение [!nЖёлтый !gЗелёный !tКомандный!n]",
    "..."
]
```

### Квары
`amxmodx/configs/plugins/AdvertMessages/Cvars.cfg`

#### **`AdvertMessages_Delay`**
- Интервал между сообщениями.
- По умолчанию: 30.0

#### **`AdvertMessages_Prefix`**
- Префикс информационных сообщений.
- По умолчанию: "!g[!tAdvert!g]!t"