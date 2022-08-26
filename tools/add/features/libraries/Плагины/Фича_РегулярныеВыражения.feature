# language: ru

@IgnoreOnWeb

Функционал: Регулярные выражения
	Как Пользователь VB
 	Я хочу выполнять больше различных проверок, используя регулярные выражения
    Чтобы автоматизировать рутинную деятельность разработчика

Сценарий: Соответствие шаблону
    Когда Я запоминаю значение выражения "345" в переменную "ПроверяемаяСтрока"
    Тогда переменная "ПроверяемаяСтрока" соответствует регулярному выражению "\d\d\d"

Сценарий: Соответствие простому шаблону с использованием маски "*", т.е. "любые символы"
    Когда Я запоминаю строку "Привет" как переменную "ПроверяемаяСтрока"
    Тогда переменная "ПроверяемаяСтрока" соответствует простому шаблону "*ри*"

Сценарий: Несовпадение с шаблоном
    Когда Я запоминаю значение выражения "345" в переменную "ПроверяемаяСтрока"
    Тогда переменная "ПроверяемаяСтрока" не соответствует регулярному выражению "\d{4}"

Сценарий: Несовпадение с простым шаблоном с использованием маски "*", т.е. "любые символы"
    Когда Я запоминаю строку "Привет" как переменную "ПроверяемаяСтрока"
    Тогда переменная "ПроверяемаяСтрока" не соответствует простому шаблону "*ДругойТекст*"

Сценарий: Пустые строки равны пустому шаблону
    Когда Я запоминаю строку "" как переменную "ПроверяемаяСтрока"
    Тогда переменная "ПроверяемаяСтрока" соответствует регулярному выражению ""

Сценарий: Соответствие строки с пробелами простому шаблону с использованием маски "*"
    Когда Я запоминаю строку "Строка с пробелами" как переменную "ПроверяемаяСтрока"
    Тогда переменная "ПроверяемаяСтрока" соответствует простому шаблону "Строка*с*пробелами"

Сценарий: Соответствие сложной строки с пробелами и другими символами простому шаблону с использованием маски "*"
    Когда Я запоминаю строку "	- Версия Vanessa-ADD: ver 6.5.0" как переменную "ПроверяемаяСтрока"
    Тогда переменная "ПроверяемаяСтрока" соответствует простому шаблону "*Версия*Vanessa-ADD*"
    Тогда переменная "ПроверяемаяСтрока" соответствует простому шаблону "Версия Vanessa-ADD: *"
    Тогда переменная "ПроверяемаяСтрока" соответствует простому шаблону "- Версия Vanessa-ADD: *.*.*"

Сценарий: Соответствие мультистрочной строки с пробелами и другими символами простому шаблону с использованием маски "*"
    Когда Я запоминаю в переменную "ПроверяемаяСтрока" строку
    """
		<!DOCTYPE html>
		<html>
		<head>
		<met a http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<met a name="viewport" content="width=device-width, initial-scale = 1.0, maximum-scale = 1.0, user-scalable=no">
		<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.2.2/pdf.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.2.2/pdf.worker.min.js"></script>
		<canvas id="the-canvas"></canvas>
		<script>
		// atob() is used to convert base64 encoded PDF to binary-like data.
		// (See also https://developer.mozilla.org/en-US/docs/Web/API/WindowBase64/
		// Base64_encoding_and_decoding.)
		var pdfData = atob(`JVBERi0xLjcKJeLjz9MKMSAwIG9iago8PAovRmls
    """
    # Когда Я запоминаю строку "	- Версия Vanessa-ADD: ver 6.5.0" как переменную "ПроверяемаяСтрока"
    Тогда переменная "ПроверяемаяСтрока" соответствует простому шаблону "*<!DOCTYPE html>*"
    Тогда переменная "ПроверяемаяСтрока" соответствует простому шаблону "<html>"
    Тогда переменная "ПроверяемаяСтрока" соответствует простому шаблону "var pdfData ="

Сценарий: Запоминание мультистрочной строки как глобальной переменной
    Когда Я запоминаю в глобальную переменную "ПроверяемаяСтрока" строку
    """
		<!DOCTYPE html>
		<html>
		// Base64_encoding_and_decoding.)
		var pdfData = atob(`JVBERi0xLjcKJeLjz9MKMSAwIG9iago8PAovRmls
    """
    Тогда глобальная переменная "ПроверяемаяСтрока" соответствует простому шаблону "var pdfData ="
    Тогда глобальная переменная "ПроверяемаяСтрока" не соответствует простому шаблону "неверно"

Сценарий: Соответствие шаблону - глобальная
    Когда Я запоминаю значение выражения "345" в переменную "ПроверяемаяСтрока" глобально
    Тогда глобальная переменная "ПроверяемаяСтрока" соответствует регулярному выражению "\d\d\d"

Сценарий: Соответствие простому шаблону с использованием маски "*", т.е. "любые символы" - глобальная
    Когда Я запоминаю строку "Привет" как переменную "ПроверяемаяСтрока" глобально
    Тогда глобальная переменная "ПроверяемаяСтрока" соответствует простому шаблону "*ри*"

Сценарий: Несовпадение с шаблоном - глобальная
    Когда Я запоминаю значение выражения "345" в переменную "ПроверяемаяСтрока" глобально
    Тогда глобальная переменная "ПроверяемаяСтрока" не соответствует регулярному выражению "\d{4}"
