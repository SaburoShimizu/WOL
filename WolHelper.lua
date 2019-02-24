function apdeit()
    async_http_request('GET', 'https://raw.githubusercontent.com/SaburoShimizu/PrisonHelper/master/PrisonHelperVer', nil --[[параметры запроса]],
        function(resp) -- вызовется при успешном выполнении и получении ответа
            newvers = resp.text:match('Version = (.+), URL.+') if newvers > thisScript().version then sampAddChatMessage(teg ..'Обнаружено обновление до v.{FF0000}'..newvers ..'{01A0E9}. Для обновления используйте /prisonmenu', - 1) elseif newvers == thisScript().version then sampAddChatMessage(teg..'У вас актуальная версия скрипта.', - 1) elseif newvers < thisScript().version then sampAddChatMessage(teg..'У вас тестовая версия скрипта.', - 1) end
            print('Проверка обновления')
        end,
        function(err) -- вызовется при ошибке, err - текст ошибки. эту функцию можно не указывать
            print(err)
            sampAddChatMessage(teg ..'Ошибка поиска версии. Попробуйте позже.', - 1)
    end)
end



function updates()
    async_http_request('GET', 'https://raw.githubusercontent.com/SaburoShimizu/PrisonHelper/master/PrisonHelper.lua', nil --[[параметры запроса]],
        function(respe) -- вызовется при успешном выполнении и получении ответа
            if #respe.text > 0 then
                f = io.open(getWorkingDirectory() ..'/PrisonHelper.lua', 'wb')
                f:write(u8:decode(respe.text))
                f:close()
                sampAddChatMessage(teg ..'Обновление успешно скачалось. Скрипт перезапуститься автоматически', - 1)
                thisScript():reload()
            else
                sampAddChatMessage(teg ..'Ошибка обновления. Попробуйте позже', - 3)
            end
            print('Установка обновления скрипта')
        end,
        function(err) -- вызовется при ошибке, err - текст ошибки. эту функцию можно не указывать
            print(err)
            sampAddChatMessage(teg ..'Ошибка обновления. Попробуйте позже.', - 1)
    end)
end
