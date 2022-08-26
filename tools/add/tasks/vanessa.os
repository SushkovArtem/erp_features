#Использовать v8runner
#Использовать cmdline
#Использовать logos
#Использовать 1commands
#Использовать "."

Перем ВозможныеКоманды;
Перем Лог;
Перем ЭтоWindows;

Процедура ИнициализацияВанесса()

	Лог = Логирование.ПолучитьЛог("oscript.app.vanessa-runner");
	Лог.УстановитьРаскладку(ЭтотОбъект);

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоWindows = Найти(ВРег(СистемнаяИнформация.ВерсияОС), "WINDOWS") > 0;

	УровеньЛога = Лог.Уровень();

	ВозможныеКоманды = Новый Структура("file, server", "file", "server");
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Лог1 = Логирование.ПолучитьЛог("oscript.lib.cmdline");
	Лог1.УстановитьУровень(УровеньЛога);
	
	Парсер.ДобавитьИменованныйПараметр("--tag", "Тэг для запуска", Истина); //
	Парсер.ДобавитьИменованныйПараметр("--path", "Путь для запуска тестов", Истина);
	Парсер.ДобавитьИменованныйПараметр(Исходники.КлючКаталогБинарныхФайлов(), "Каталог сборки исходников");
	Парсер.ДобавитьИменованныйПараметр("--settings", "Файл настроек ванессы", Истина);

	ОписаниеКоманды = Парсер.ОписаниеКоманды("all");
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
	ОписаниеКоманды = Парсер.ОписаниеКоманды("debug");
	Парсер.ДобавитьКоманду(ОписаниеКоманды);

	Аргументы = Парсер.РазобратьКоманду(АргументыКоманднойСтроки);

	Если Аргументы = Неопределено Тогда
		Аргументы = Новый Структура("Команда, ЗначенияПараметров", "all", Новый Соответствие);
	КонецЕсли;

	СтрокаЗапуска = "runner vanessa";
	
	Если Аргументы.ЗначенияПараметров.Получить("--tag") <> Неопределено Тогда
		УстановитьПеременнуюСреды("VANESSA_FILTERTAGS", Аргументы.ЗначенияПараметров["--tag"]);
	КонецЕсли;

	Если Аргументы.ЗначенияПараметров.Получить("--path") <> Неопределено Тогда
		УстановитьПеременнуюСреды("VANESSA_FEATUREPATH", Аргументы.ЗначенияПараметров["--path"]);
	КонецЕсли;

	Если Аргументы.ЗначенияПараметров.Получить("--settings") <> Неопределено Тогда
		СтрокаЗапуска = СтрШаблон("%1 %2", СтрокаЗапуска, "--vanessasettings " + Аргументы.ЗначенияПараметров["--settings"]);
	КонецЕсли;

	Если НЕ ЭтоWindows Тогда
		Если ЗначениеЗаполнено(ПолучитьПеременнуюСреды("WAYLAND_DISPLAY")) Тогда
			УстановитьПеременнуюСреды("VANESSA_commandscreenshot", 
				"dbus-send --type=method_call --print-reply --dest=org.gnome.Shell.Screenshot /org/gnome/Shell/Screenshot org.gnome.Shell.Screenshot.Screenshot boolean:true boolean:false string:");
		Иначе
			УстановитьПеременнуюСреды("VANESSA_commandscreenshot", "import -window root ");
		КонецЕсли;
	КонецЕсли;

	БезОжидания = Ложь;
	Если (Аргументы.Команда = "debug") Тогда
		БезОжидания = Истина;
		УстановитьПеременнуюСреды("VANESSA_vanessashutdown", "false");
		УстановитьПеременнуюСреды("VANESSA_startfeatureplayer", "false");
	КонецЕсли;

	Результат = ЗапуститьИПодождать(СтрокаЗапуска, БезОжидания);
	Если Результат.КодВозврата <> 0 Тогда
		Лог.Ошибка("Код возврат " +Результат.КодВозврата);
		ВызватьИсключение "Неверный код возврата " + Результат.КодВозврата;
	КонецЕсли;

КонецПроцедуры

Функция ЗапуститьИПодождать(СтрокаЗапуска, БезОжидания = Ложь)
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.УстановитьСтроку();

	Процесс = СоздатьПроцесс(СтрокаЗапуска, "./", Истина, Истина);
	Попытка
		Процесс.Запустить();
	Исключение
		Если ЭтоWindows Тогда
			ШаблонЗапуска = "cmd /c %1";
		Иначе
			ШаблонЗапуска = "sh -c '%1'";
		КонецЕсли;
		Процесс = СоздатьПроцесс(СтрШаблон(ШаблонЗапуска, СтрокаЗапуска), "./", Истина, Истина);
		Процесс.Запустить();
	КонецПопытки;

	Если БезОжидания Тогда
		Возврат Новый Структура("КодВозврата, Результат", 0, "");
	КонецЕсли;
	ПериодОпросаВМиллисекундах = 1000;
	Если ПериодОпросаВМиллисекундах <> 0 Тогда
		Приостановить(ПериодОпросаВМиллисекундах);
	КонецЕсли;
	Пока НЕ Процесс.Завершен ИЛИ Процесс.ПотокВывода.ЕстьДанные ИЛИ Процесс.ПотокОшибок.ЕстьДанные Цикл
		//Сообщить(""+ ТекущаяДата() + " Завершен:"+Строка(Процесс.Завершен) + Строка(Процесс.ПотокВывода.ЕстьДанные) + Строка(Процесс.ПотокОшибок.ЕстьДанные) );
		Если ПериодОпросаВМиллисекундах <> 0 Тогда
			Приостановить(ПериодОпросаВМиллисекундах);
		КонецЕсли;

		ОчереднаяСтрокаВывода = Процесс.ПотокВывода.Прочитать();
		ОчереднаяСтрокаОшибок = Процесс.ПотокОшибок.Прочитать();

		Если Не ПустаяСтрока(ОчереднаяСтрокаВывода) Тогда
			ОчереднаяСтрокаВывода = СтрЗаменить(ОчереднаяСтрокаВывода, Символы.ВК, "");
			Если ОчереднаяСтрокаВывода <> "" Тогда
				Лог.Информация("%1", ОчереднаяСтрокаВывода);
				ЗаписьXML.ЗаписатьБезОбработки(ОчереднаяСтрокаВывода);
			КонецЕсли;
		КонецЕсли;

		Если Не ПустаяСтрока(ОчереднаяСтрокаОшибок) Тогда
			ОчереднаяСтрокаОшибок = СтрЗаменить(ОчереднаяСтрокаОшибок, Символы.ВК, "");
			Если Найти(ОчереднаяСтрокаОшибок, "PING") > 0 Тогда
				Продолжить;
			КонецЕсли;

			Если ОчереднаяСтрокаОшибок <> "" Тогда
				//Сообщить(ОчереднаяСтрокаОшибок);
				Лог.Информация("%1", ОчереднаяСтрокаОшибок);
				ЗаписьXML.ЗаписатьБезОбработки(ОчереднаяСтрокаОшибок);
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	ОчереднаяСтрока = СтрЗаменить(Процесс.ПотокВывода.Прочитать(), Символы.ВК, "");
	Лог.Информация("%2%1", ОчереднаяСтрока, Символы.ПС);
	ЗаписьXML.ЗаписатьБезОбработки(ОчереднаяСтрока);
	РезультатРаботыПроцесса = ЗаписьXML.Закрыть();

	Возврат Новый Структура("КодВозврата, Результат", Процесс.КодВозврата, РезультатРаботыПроцесса);

КонецФункции // ЗапуститьИПодождать(СтрокаЗапуска)

Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт

	Возврат СтрШаблон("%1: %2 - %3", ТекущаяДата(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);

КонецФункции

ИнициализацияВанесса();
