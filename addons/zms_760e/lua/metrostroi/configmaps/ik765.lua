--------------------------------------------------------------------------------
-- Конфиги ЦИК для 81-765 с обратной совместимостью с ЦИС.
-- Если на карте присутствует хотя бы один конфиг с префиксом [ИК] в названии,
-- то в спавнере будут отображаться только конфиги с этим префиксом.
--------------------------------------------------------------------------------

local map = game.GetMap()

if map:find("kalinin") then
    Metrostroi.AddCISConfig("[ИК] Калининская 2025", {{
        -- Здесь все точно так же, как и в обычном конфиге ЦИС, для обратной совместимости с Окой.
        LED = {3, 4, 4, 4, 4, 4, 4, 3},
        Name = "Новокосино - Третьяковская",
        Loop = false,
        Line = 8,
        Color = Color(255,205,30),
        English = true,
        { 801, "Новокосино","Novokosino",true,"Реутов",4,"Reutov",Color(63,180,133), },
        { 802, "Новогиреево","Novogireyevo",true,"Новогиреево",4,"Novogireyevo",Color(63,180,133), },
        { 803, "Перово","Perovo", },
        { 804, "Шоссе Энтузиастов","Shosse Entuziastov",true,"Шоссе Энтузиастов",14,"Shosse Entuziastov",Color(198,70,64), },
        { 805, "Авиамоторная","Aviamotornaya",true,"Авиамоторная",11,"Aviamotornaya",Color(108,163,162),3,"Авиамоторная",3,"Aviamotornaya",Color(225,93,41), },
        { 806, "Площадь Ильича","Ploschad Ilyicha",true,"Римская",10,"Rimskaya",Color(190,209,46),"Москва-Товарная",3,"Moskva-Tovarnaya",Color(223,71,124), },
        { 807, "Марксистская","Marksistskaya",true,"Таганская",5,"Taganskaya",Color(146,82,51),"Таганская",7,"Taganskaya",Color(148,63,144), },
        { 808, "Третьяковская","Tretyakovskaya",true,"Третьяковская",6,"Tretyakovskaya",Color(239,126,36),"Новокузнецкая",2,"Novokuznetskaya",Color(75,175,79), },

        -- Отсюда идет расширение для ЦИК.
        -- Если это поле предоставлено, то пересадки, определенные выше, игнорируются ЦИКом для указанных в этом поле станций.
        changes = {
            [1] = {  -- Порядковый номер станции, начинающийся с единицы, в каком порядке они перечислены выше.
                {
                    name = "Реутов",
                    nameEng = "Reutov",
                    icons = {
                        -- Иконок может быть несколько, если одна станция обслуживает несколько направлений (например, Александровский сад - 4 и 4А)
                        -- Но в подавляющем большинстве случаев, тут только одна иконка.
                        {
                            -- Типы перечислены в lua/autorun/ik765.lua, и по идее все глобалы оттуда всегда доступны во всех скриптах configmaps, как этот
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            -- Цвет только в HEX. Для кастомных иконок это почти всегда должно быть "#ffffff"
                            color = "#ffffff",
                            -- Можно предоставить свою PNG, например path = "foo/bar/baz.png"
                            path = IK_ICON_MCD4,
                        }
                    }
                },
                IK_TEMPLATE_PARKING, IK_TEMPLATE_ACCESS  -- Шаблоны парковок и значка инвалидов. Все шаблоны перечислены в lua/autorun/ik765.lua
            },
            [2] = {
                {
                    name = "Новогиреево",
                    nameEng = "Novogireevo",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD4,
                        }
                    }
                }
            },
            [4] = {
                {
                    name = "Шоссе Энтузиастов",
                    nameEng = "Shosse Entuziastov",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCC,
                        }
                    }
                }
            },
            [5] = {
                {
                    name = "Авиамоторная",
                    nameEng = "Aviamotornaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,  -- Пересадка на обычную линию метро
                            symbol = "11",  -- БКЛ
                            color = "#82C0C0",  -- Цвет рекомендуется брать из википедии через F12, если это реальная линия
                        }
                    }
                }, {
                    name = "Авиамоторная",
                    nameEng = "Aviamotornaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD3,
                        }
                    }
                }
            },
            [6] = {
                {
                    name = "Римская",
                    nameEng = "Rimskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "10",  -- ЛДЛ
                            color = "#99CC00",
                        }
                    }
                }, {
                    name = "Москва-Товарная",
                    nameEng = "Moskva-Tovarnaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD2,
                        }
                    }
                }, {
                    name = "Серп и Молот",
                    nameEng = "Serp i Molot",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD4,
                        }
                    }
                }
            },
            [7] = {
                {
                    name = "Таганская",
                    nameEng = "Taganskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "5",  -- КЛ
                            color = "#8D5B2D",
                        }, {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "7",  -- ТКЛ
                            color = "#800080",
                        }
                    }
                }
            },
            [8] = {
                {
                    name = "Третьяковская",
                    nameEng = "Tretyakovskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "6",  -- КРЛ
                            color = "#ED9121",
                        }
                    }
                }, {
                    name = "Новокузнецкая",
                    nameEng = "Novokuznetskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "2",  -- ЗЛ
                            color = "#2DBE2C",
                        }
                    }
                }
            },
        }
    }})
elseif map:find("nekrasovskaya") then
    Metrostroi.AddCISConfig("[ИК] Некрасовская 2025", {{
        LED = {3, 3, 3, 3, 3, 3, 3, 9},
        Name = "Некрасовка - Нижегородская",
        Loop = false,
        Line = 15,
        Color = Color(208,126,167),
        English = true,
        { 101, "Некрасовка","Nekrasovka", },
        { 102, "Лухмановская","Lukhmanovskaya", },
        { 103, "Улица Дмитриевского","Ulitsa Dmitrievskogo", },
        { 104, "Косино","Kosino",true,"Лермонтовский проспект",7,"Lermontovsky Prospekt",Color(120,70,145),"Косино",3,"Kosino",Color(225,93,41), },
        { 105, "Юго-Восточная","Yugo-Vostochnaya", },
        { 106, "Окская","Okskaya", },
        { 107, "Стахановская","Stakhanovskaya", },
        { 108, "Нижегородская","Nizhegorodskaya",true,"Нижегородская",11,"Nizhegorodskaya",Color(108,163,162),"Нижегородская",4,"Nizhegorodskaya",Color(63,180,133),"Нижегородская МЦК",14,"Nizhegorodskaya MCC",Color(190,45,44) },
        changes = {
            [1] = { IK_TEMPLATE_ACCESS },
            [2] = { IK_TEMPLATE_ACCESS },
            [3] = { IK_TEMPLATE_ACCESS },
            [4] = {
                {
                    name = "Лермонтовский проспект",
                    nameEng = "Lermontovsky Prospekt",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "7",
                            color = "#800080",
                        }
                    }
                }, {
                    name = "Косино",
                    nameEng = "Kosino",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD3,
                        }
                    }
                },
                IK_TEMPLATE_ACCESS
            },
            [5] = { IK_TEMPLATE_ACCESS },
            [6] = { IK_TEMPLATE_ACCESS },
            [7] = { IK_TEMPLATE_ACCESS },
            [8] = {
                -- Хоть все три станции и называются "Нижегородская", но это все еще три отдельные станции, поэтому не группируем
                {
                    name = "Нижегородская",
                    nameEng = "Nizhegorodskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "11",
                            color = "#82C0C0",
                        }
                    }
                }, {
                    name = "Нижегородская",
                    nameEng = "Nizhegorodskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCC,
                        }
                    }
                }, {
                    name = "Нижегородская",
                    nameEng = "Nizhegorodskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD4,
                        }
                    }
                },
                IK_TEMPLATE_ACCESS
            },
        }
    }})
elseif map:find("kaluzhskaya") then
    Metrostroi.AddCISConfig("[ИК] Калужский радиус 2025", {{
        LED = {5, 5, 5, 5, 5, 5},
        Name = "Новые Черёмушки - Октябрьская",
        Loop = false,
        Line = 6,
        Color = Color(237, 145, 33),
        English = true,
        { 601, "Новые Черёмушки","Novye Cheryomushki",},
        { 602, "Профсоюзная","Profsoyuznaya",},
        { 603, "Академическая","Akademicheskaya",true,"Академическая",16,"Akademicheskaya",Color(3, 121, 95) },
        { 604, "Ленинский проспект","Leninsky Prospekt",true,"Площадь Гагарина",14,"Ploshchad Gagarina",Color(198,70,64), },
        { 605, "Шаболовская","Shabolovskaya", },
        { 606, "Октябрьская","Oktyabrskaya",true,"Октябрьская",5,"Oktyabrskaya",Color(137, 78, 53),},
        changes = {
            [3] = {
                {
                    name = "Академическая",
                    nameEng = "Akademicheskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "16",
                            color = "#03795F",
                        }
                    }
                }
            },
            [4] = {
                {
                    name = "Площадь Гагарина",
                    nameEng = "Ploshchad Gagarina",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCC,
                        }
                    }
                }
            },
            [6] = {
                {
                    name = "Октябрьская",
                    nameEng = "Oktyabrskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "5",
                            color = "#8D5B2D",
                        }
                    }
                }
            },
        },
    }})
elseif map:find("mosldl") then
    Metrostroi.AddCISConfig("[ИК] Люблинский радиус 2025", {{
        LED = {6, 6, 6, 6, 6},
        Name = "Дубровка - Люблино",
        Loop = false,
        Line = 10,
        Color = Color(187, 210, 82),
        English = true,
        { 109, "Дубровка","Dubrovka",true,"Дубровка",14,"Dubrovka",Color(198,70,64), },
        { 108, "Кожуховская","Kozhukhovskaya",true,"Дубровка",14,"Dubrovka",Color(198,70,64), },
        { 107, "Печатники","Pechatniki",true,"Печатники",11,"Pechatniki",Color(108,163,162),"Печатники",2,"Pechatniki",Color(234, 64, 131),},
        { 106, "Волжская","Volzhskaya",},
        { 105, "Люблино","Lyublino", },
        changes = {
            [1] = {
                {
                    name = "Дубровка",
                    nameEng = "Dubrovka",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCC,
                        }
                    }
                }
            },
            [2] = {
                {
                    name = "Дубровка",
                    nameEng = "Dubrovka",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCC,
                        }
                    }
                }
            },
            [3] = {
                {
                    name = "Печатники",
                    nameEng = "Pechatniki",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "11",
                            color = "#82C0C0",
                        }
                    }
                }, {
                    name = "Печатники",
                    nameEng = "Pechatniki",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD2,
                        }
                    }
                }, {
                    name = "Люблино",
                    nameEng = "Lyublino",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD2,
                        }
                    }
                }
            },
        }
    }})
elseif map:find("chapaevskaya") then
    Metrostroi.AddCISConfig("[ИК] Чапаевская линия", {{
        LED = {3, 6, 6, 6, 6, 6, 6, 3},
        Name = "Заря - Красноярская",
        Loop = false,
        Line = 1,
        Color = Color(93, 0, 156),
        BlockDoors = true,
        English = true,
        { 101, "Заря","Zarya", right_doors = true },
        { 102, "Чапаевский парк","Chapaevskiy Park", right_doors = true },
        { 103, "Ярославская","Yaroslavskaya", right_doors = true },
        { 104, "Перловская","Perlovskaya",true,"Стадион Народов",2,"Stadion Narodov",Color(255,0,24), right_doors = true },
        { 105, "Куликовская","Kulikovskaya", },
        { 106, "Токоями","Tokoyami",true,"Пушкинские Горы",3,"Pushkinskie Gory",Color(41,218,241) },
        { 107, "Есенинская","Eseninskaya", },
        { 108, "Красноярская","Krasnoyarskaya", },
        changes = {
            [1] = {
                {
                    name = "платформа Заря",
                    nameEng = "Zarya train platform",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NOCHANGE,
                            color = "#ffffff",
                            path = IK_ICON_ZHD,
                        }
                    }
                }
            },
            [4] = {
                {
                    name = "Стадион Народов",
                    nameEng = "Stadion Narodov",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            color = "#ff0018",
                            symbol = "2",
                        }
                    }
                }
            },
            [6] = {
                {
                    name = "Стадион Народов",
                    nameEng = "Stadion Narodov",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            color = "#29DAF1",
                            symbol = "3",
                        }
                    }
                }
            },
            [7] = {
                {
                    name = "станция Есенинская",
                    nameEng = "Eseninskaya train station",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NOCHANGE,
                            color = "#ffffff",
                            path = IK_ICON_ZHD,
                        }
                    }
                }
            }
        }
    }})
elseif map:find("crossline_r199h") then
    Metrostroi.AddCISConfig("[ИК] Кировская линия", {{
        LED = {3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
        Name = "Международная - Молодёжная",
        Loop = false,
        Line = 1,
        Color = Color(188, 17, 32),
        BlockDoors = true,
        English = true,
        { 101, "Международная","Mezhdunarodnaya" },
        { 102, "Парк Культуры","Park Kultury" },
        { 103, "Политехническая","Politekhnicheskaya" },
        { 104, "Проспект Суворова","Prospekt Suvorova" },
        { 105, "Нахимовская","Nakhimovskaya" },
        { 106, "Октябрьская","Oktyabr'skaya", true,"Московский вокзал",1,"Moskovskiy rail terminal",Color(255,255,255) },
        { 107, "Речная","Rechnaya" },
        { 108, "Пролетарская","Proletarskaya" },
        { 109, "Олимпийская","Olimpiyskaya" },
        { 110, "Молодёжная","Molodezhnaya" },
        changes = {
            [6] = {
                {
                    name = "Московский вокзал",
                    nameEng = "Moskovskiy rail terminal",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NOCHANGE,
                            color = "#ffffff",
                            path = IK_ICON_ZHD,
                        }
                    }
                }
            }
        }
    }})

elseif map:find("tkl") then
    Metrostroi.AddCISConfig("[ИК] Таганский радиус", {{
        LED = {3, 3, 3, 3, 3, 3, 3, 4, 5},
        Name = "Котельники - Пролетарская",
        Loop = false,
        Line = 7,
        Color = Color(163,93,148),
        English = true,
        { 701, "Пролетарская","Proletarskaya",true,"Крестьянская Застава",10,"Krestyanskaya Zastava",Color(190,209,38) },
        { 702, "Волгоградский проспект","Volgogradskiy prospekt",true,"Угрешская МЦК",14,"Ugreshskaya MCC",Color(237,26,45) },
        { 703, "Текстильщики","Tekstilshiki",true,"Текстильщики",11,"Tekstilshiki",Color(136,204,207),"Текстильщики",2,"Tekstilshiki",Color(234, 64, 131), },
        { 704, "Кузьминки","Kuzminki", },
        { 705, "Рязанский проспект","Ryazanskiy prospekt",true,"Вешняки",3,"Veshnyaki",Color(225,93,41), },
        { 706, "Выхино","Vykhino",true,"Выхино",3,"Vykhino",Color(225,93,41), },
        { 707, "Лермонтовский проспект","Lermontovskiy prospekt",true,"Косино",15,"Kosino",Color(208,126,167),"Косино",3,"Kosino",Color(225,93,41), },
        { 708, "Жулебино","Zhulebino", },
        { 709, "Котельники","Kotelniki", },
        changes = {
            [7] = {
                {
                    name = "Косино",
                    nameEng = "Kosino",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "15",
                            color = "#FFC0CB",
                        }
                    }
                }, {
                    name = "Косино",
                    nameEng = "Kosino",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD3,
                        }
                    }
                },
            },
            [6] = {
                {
                    name = "Выхино",
                    nameEng = "Vykhino",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD3,
                        }
                    }
                }
            },
            [5] = {
                {
                    name = "Вешняки",
                    nameEng = "Veshnyaki",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD3,
                        }
                    }
                }
            },
            [3] = {
                {
                    name = "Текстильщики",
                    nameEng = "Tekstilshiki",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "11",
                            color = "#82C0C0",
                        }
                    }
                }, {
                    name = "Текстильщики",
                    nameEng = "Tekstilshiki",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCD2,
                        }
                    }
                },
            },
            [2] = {
                {
                    name = "Угрешская",
                    nameEng = "Ugreshskaya",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_CUSTOM,
                            color = "#ffffff",
                            path = IK_ICON_MCC,
                        }
                    }
                }
            },
            [1] = {
                {
                    name = "Крестьянская Застава",
                    nameEng = "Krestyanskaya Zastava",
                    icons = {
                        {
                            typ = IK_CHANGE_TYPE_NORMAL,
                            symbol = "10",
                            color = "#99CC00",
                        }
                    }
                }
            }
        }
    }})

-- elseif map:find("minsk_1984") then
--     Metrostroi.AddCISConfig("[ИК] Минск 2025", {{
--         LED = {3, 4, 4, 4, 4, 4, 4, 3},
--         Name = "Институт культуры - Московская",
--         Loop = false,
--         Line = 2,
--         Color = Color(27, 89, 220),
--         English = true,
--         { 601, "Новые Черёмушки","Novye Cheryomushki",},
--         { 602, "Профсоюзная","Profsoyuznaya",},
--         { 603, "Академическая","Akademicheskaya",true,"Академическая",16,"Akademicheskaya",Color(3, 121, 95) },
--         { 604, "Ленинский проспект","Leninsky Prospekt",true,"Площадь Гагарина",14,"Ploshchad Gagarina",Color(198,70,64), },
--         { 605, "Шаболовская","Shabolovskaya", },
--         { 606, "Октябрьская","Oktyabrskaya",true,"Октябрьская",5,"Oktyabrskaya",Color(137, 78, 53),},
--         { 606, "Октябрьская","Oktyabrskaya",true,"Октябрьская",5,"Oktyabrskaya",Color(137, 78, 53),},
--         { 606, "Октябрьская","Oktyabrskaya",true,"Октябрьская",5,"Oktyabrskaya",Color(137, 78, 53),},
--         changes = {
--             [3] = {
--                 {
--                     name = "Академическая",
--                     nameEng = "Akademicheskaya",
--                     icons = {
--                         {
--                             typ = IK_CHANGE_TYPE_NORMAL,
--                             symbol = "16",
--                             color = "#03795F",
--                         }
--                     }
--                 }
--             },
--             [4] = {
--                 {
--                     name = "Площадь Гагарина",
--                     nameEng = "Ploshchad Gagarina",
--                     icons = {
--                         {
--                             typ = IK_CHANGE_TYPE_CUSTOM,
--                             color = "#ffffff",
--                             path = IK_ICON_MCC,
--                         }
--                     }
--                 }
--             },
--             [6] = {
--                 {
--                     name = "Октябрьская",
--                     nameEng = "Oktyabrskaya",
--                     icons = {
--                         {
--                             typ = IK_CHANGE_TYPE_NORMAL,
--                             symbol = "5",
--                             color = "#8D5B2D",
--                         }
--                     }
--                 }
--             },
--         },
--     }})

end
