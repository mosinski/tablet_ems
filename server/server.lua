ESX = nil
fakturaAmount = nil
local societyAccount = nil

TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

TriggerEvent('esx_addonaccount:getSharedAccount', Config.Society, function(account)
    societyAccount = account
end)

ESX.RegisterServerCallback('tablet_ems:getKartoteka', function(source, cb)
	local result = MySQL.Sync.fetchAll("SELECT imie,nazwisko,policjant,powod,grzywna,ilosc_lat,data FROM gracz_kartoteka ORDER BY data desc LIMIT 50")
		if result ~= nil then
			local wynik = {}

			for k,v in pairs(result) do
				local data = {}
				data.imie = result[k].imie
				data.policjant = result[k].policjant
				data.powod = result[k].powod
				data.grzywna = result[k].grzywna
				data.ilosc_lat = result[k].ilosc_lat
				data.dataaa = result[k].data
				data.nazwisko = result[k].nazwisko
				table.insert(wynik, data)
            end
			cb(wynik)
        end
end)

RegisterNetEvent('tablet_ems:addTreatment')
AddEventHandler('tablet_ems:addTreatment', function(userIdentifier, details, price, recovery)
  local _source = source
  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local userPlayer = ESX.GetPlayerFromId(userIdentifier)
  local medicIdentifier = sourceXPlayer.getIdentifier()

  MySQL.Async.execute('INSERT INTO `ems_user_treatments` (`userId`, `medicId`, `operations`, `fee`, `recoveryDate`) VALUES (@userId, @medicId, @operations, @fee, @recoveryDate)',{
    ['@userId'] = userIdentifier,
    ['@medicId'] = medicIdentifier,
    ['@operations'] = details,
    ['@fee'] = price,
	['@recoveryDate'] = recovery
  },
    function()
	  userPlayer.removeBank(price);
	  societyAccount.addMoney(price);
	  TriggerServerEvent("route68:hospitalPlayer", userIdentifier, recovery - os.time());
	end
  );
end)

RegisterNetEvent('tablet_ems:getTreatments')
AddEventHandler('tablet_ems:getTreatments', function()
  local results = MySQL.Sync.fetchAll("SELECT patients.firstname AS patientFirstName, patients.lastname AS patientLastName, medics.firstname AS medicFirstName, medics.lastname AS medicLastName, userId, medicId, operations, fee, recoveryDate, DATE FROM ems_user_treatments LEFT JOIN users AS patients ON patients.identifier = ems_user_treatments.userId INNER JOIN users AS medics ON medics.identifier = ems_user_treatments.medicId ORDER BY DATE DESC LIMIT 10")

  if results ~= nil then
    local wynik = {}

	for k,v in pairs(results) do
	  local data = {}
	  data.patient = results[k].patientFirstName .. ' ' .. results[k].patientLastName
	  data.medic = results[k].medicFirstName .. ' ' .. results[k].medicLastName
	  data.operations = results[k].operations
	  data.fee = results[k].fee
	  data.recoveryDate = results[k].recoveryDate
	  data.date = results[k].DATE

	  table.insert(wynik, data)
    end

	TriggerClientEvent('tablet_ems:showTreatments', source, wynik)
  end
end)

RegisterNetEvent('tablet_ems:getPatients')
AddEventHandler('tablet_ems:getPatients', function(query)
  local results = MySQL.Sync.fetchAll("SELECT firstname, lastname, identifier, job, dateofbirth FROM users WHERE LOWER(firstname) LIKE LOWER('%" .. query .. "%') OR LOWER(lastname) LIKE LOWER('%" .. query .. "%') LIMIT 10")

  if results ~= nil then
    local wynik = {}

	for k,v in pairs(results) do
	  local data = {}
	  data.name = results[k].firstname .. ' ' .. results[k].lastname
	  data.identifier = results[k].identifier
	  data.job = results[k].job
	  data.dateofbirth = results[k].dateofbirth

	  table.insert(wynik, data)
    end

	TriggerClientEvent('tablet_ems:autocompletePatients', source, wynik)
  end
end)

RegisterNetEvent('tablet_ems:getPlayerName')
AddEventHandler('tablet_ems:getPlayerName', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  local identifier = xPlayer.getIdentifier()
  local results = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier LIMIT 1", {
    ['@identifier'] = identifier
  })

  if results ~= nil then
    local name = results[1].firstname .. ' ' .. results[1].lastname

	TriggerClientEvent('tablet_ems:setPlayerName', source, name)
  end
end)

RegisterNetEvent('tablet_ems:getClosestPlayer')
AddEventHandler('tablet_ems:getClosestPlayer', function(identifier)
  local results = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier LIMIT 1", {
    ['@identifier'] = identifier
  })

  if results ~= nil then
    local name = results[1].firstname .. ' ' .. results[1].lastname

	TriggerClientEvent('tablet_ems:setPlayerName', source, identifier, name)
  end
end)

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
	  ['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].firstname ~= nil and result[1].lastname ~= nil then
		return result[1].firstname .. ' ' .. result[1].lastname
	else
		return GetPlayerName(source)
	end
end

function GetImie(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
	  ['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].firstname ~= nil then
		return result[1].firstname
	else
		return GetPlayerName(source)
	end
end

function GetNazwisko(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
	  ['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].lastname ~= nil then
		return result[1].lastname
	else
		return GetPlayerName(source)
	end
end
