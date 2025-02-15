# language: ru

@IgnoreOnWeb

Функционал: Загрузка тысячи элементов справочника из Макета
	Как Пользователь VB
 	Я хочу загружать большое количество однотипных элементов из макета
    Чтобы Автоматизировать рутинную деятельность разработчика

Контекст:
 	Дано:  Имеется метаданное "Справочник.Справочник1"
	и существует макет "ТысячаЭлементовСправочника1"

Сценарий: Загрузка тысячи элементов справочника с одинаковым наименованием из Макета
    * важно для генерации правильных имен переменных в генераторе данных
    Когда я удаляю все элементы справочника "Справочник1"
    И я загружаю макет "ТысячаЭлементовСправочника1"
    Тогда В списке элементов справочника "Справочник1" существует не менее 1000 элементов
