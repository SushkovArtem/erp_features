﻿# language: ru

@IgnoreOn82Builds
@IgnoreOnOFBuilds
@IgnoreOn837
@IgnoreOn836

@IgnoreOnWeb8310

Функционал: Проверка негативного поведения шага 

Как Разработкич
Я хочу получать подтверждение не возможности выполнения шага
Чтобы проверять негативное поведение шага без остановки сценария

Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: Выполнение негативного сценария

	Когда В панели разделов я выбираю "Основная"
	И     В панели функций я выбираю "Справочник1"
	Тогда открылось окно "Справочник1"
	И     я нажимаю на кнопку "Создать"
	Тогда открылось окно "Справочник1 (создание)"

	# Проверка отсутствия значения
	Тогда Проверяю шаги на Исключение:
		|'И     в поле с именем "Наименование2" я ввожу текст "Тестовый Элемент"'|
