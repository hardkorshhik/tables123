# Информация о курсах валют в PostgreSQL

## Анализ 1000 записей
 - Анализ на конкретную дату: 0.165ms
 - Анализ минимальных и максимальных значений: 0.150ms

 > После добавления индексов на поля currency_id, exchange_date, rate мы получили следующий результат: 
 - Анализ на конкретную дату: 0.148ms
 - Анализ минимальных и максимальных значений: 0.212ms

## Анализ 10000 записей
 - Анализ на конкретную дату: 0.833ms
 - Анализ минимальных и максимальных значений: 0.676ms

 > После добавления индексов на поля currency_id, exchange_date, rate мы получили следующий результат:
 - Анализ на конкретную дату: 0.168ms
 - Анализ минимальных и максимальных значений: 0.125ms


## Анализ 100000 записей
 - Анализ на конкретную дату: 5.612ms
 - Анализ минимальных и максимальных значений: 7.027ms

 > После добавления индексов на поля currency_id, exchange_date, rate мы получили следующий результат:
 - Анализ на конкретную дату: 0.132ms
 - Анализ минимальных и максимальных значений: 5.954ms

