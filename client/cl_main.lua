--[ Définition des variables ]
local HasAlreadyEnteredMarker, IsInShopMenu, isPoliceActive = false, false, false
local CurrentAction, CurrentActionMsg, LastZone, currentDisplayVehicle, CurrentVehicleData
local CurrentActionData = {}
local Scaleform = {}

--[ Récupération des commandes ESX ]
ESX = exports["es_extended"]:getSharedObject()

--[ Définition de la zone ]
local militaryBase_Zone = PolyZone:Create({
	--Liste des points définissant la zone
	vector2(-1430.6864013672, 2689.5478515625),
	vector2(-1473.4410400391, 2835.4736328125),
	vector2(-1585.6520996094, 2988.3894042969),
	vector2(-1575.1954345703, 3190.2224121094),
	vector2(-1979.5645751953, 3422.5517578125),
	vector2(-2202.2392578125, 3520.8400878906),
	vector2(-2350.9501953125, 3500.6940917969),
	vector2(-2424.30859375, 3468.1508789062),
	vector2(-2569.8591308594, 3333.1862792969),
	vector2(-2648.142578125, 3389.1477050781),
	vector2(-2972.6369628906, 3486.380859375),
	vector2(-3005.6918945312, 3421.224609375),
	vector2(-3015.3815917969, 3382.4060058594),
	vector2(-3000.5380859375, 3305.7231445312),
	vector2(-2955.4343261719, 3253.5881347656),
	vector2(-2922.986328125, 3229.0397949219),
	vector2(-2885.2941894531, 3185.2136230469),
	vector2(-2843.6943359375, 3143.5808105469),
	vector2(-2769.8454589844, 3091.0803222656),
	vector2(-2727.7316894531, 3060.6745605469),
	vector2(-2680.5261230469, 3017.033203125),
	vector2(-2654.4267578125, 2967.0849609375),
	vector2(-2633.1525878906, 2913.552734375),
	vector2(-2595.3432617188, 2881.9431152344),
	vector2(-2550.0886230469, 2860.751953125),
	vector2(-2484.6809082031, 2834.3061523438),
	vector2(-2396.0275878906, 2840.6860351562),
	vector2(-2323.0654296875, 2840.9658203125),
	vector2(-2267.5388183594, 2839.697265625),
	vector2(-2213.322265625, 2793.5751953125),
	vector2(-2187.0434570312, 2758.3427734375),
	vector2(-2156.5017089844, 2723.162109375),
	vector2(-2101.2185058594, 2707.5380859375),
	vector2(-2006.4672851562, 2709.658203125),
	vector2(-1943.4896240234, 2713.517578125),
	vector2(-1906.1049804688, 2694.6352539062),
	vector2(-1874.6873779297, 2688.4182128906),
	vector2(-1840.6916503906, 2692.6176757812),
	vector2(-1812.3928222656, 2685.7932128906),
	vector2(-1785.3414306641, 2695.5869140625),
	vector2(-1753.2315673828, 2739.3688964844),
	vector2(-1730.5428466797, 2747.7978515625),
	vector2(-1699.9133300781, 2749.6047363281),
	vector2(-1671.0766601562, 2731.9663085938),
	vector2(-1656.048828125, 2717.6120605469),
	vector2(-1636.5540771484, 2705.345703125),
	vector2(-1596.8741455078, 2732.9770507812),
	vector2(-1560.9846191406, 2714.9736328125),
	vector2(-1534.4174804688, 2698.7570800781),
	vector2(-1512.3643798828, 2687.0988769531),
	vector2(-1488.9360351562, 2683.3693847656),
	vector2(-1464.5111083984, 2684.2888183594)
  }, {
	--Définition des metadata de la zone
	name="militaryBase",
	minZ = 0.0,
	maxZ = 2700.0,
	debugGrid=false,
    gridDivisions=30
  })

--[ Action en cas d'entrée du joueur dans la zone ]  
militaryBase_Zone:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
	--Définition des variables local à la fonction
	local player = PlayerId()
	local ped = GetPlayerPed(player)
	local cds = GetEntityCoords(ped)

	--Boucle if pour les actions dès que le joueur entre dans la zone
    if isPointInside then
		countdown()	--Lancement de la fonction "countdown"
		Citizen.Wait(5 * 1000)	--Temporisation de 5 secondes

		isPoliceActive = true
		activePolice()	--Lancement de la fonction "activePolice"
    else
		showCD = false
		isPoliceActive = false
		SetPlayerWantedLevelNoDrop(player, 0, false)	--Demande de réinitialisation du niveau de wanted du joueur à 0 étoiles
		SetPlayerWantedLevelNow(player, false) --Exécution de la demande de réinitialisation immédiatement
    end
end)

--[ Thread qui retire l'ensemble des PNJ et coupe toutes les lumières de l'ile ]
Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(0) --Temporisation de 0 secondes

			local playerPed = GetPlayerPed(-1)
			local playerId = PlayerId()

			--[[ DISABLE VEHICLE GENERATORS IN PLAYER AREA ]]
			local pos = GetEntityCoords(playerPed)
			RemoveVehiclesFromGeneratorsInArea(
				pos['x'] - 500.0,
				pos['y'] - 500.0,
				pos['z'] - 500.0,
				pos['x'] + 500.0,
				pos['y'] + 500.0,
				pos['z'] + 500.0
			)
			if isPoliceActive == false then
			--[[ POLICE DISPATCH SPAWNS OFF ]]
				EnableDispatchService(1, false) --PoliceAutomobile
				EnableDispatchService(2, false) --PoliceHelicopter
				EnableDispatchService(3, false) --FireDepartment
				EnableDispatchService(4, false) --SwatAutomobile
				EnableDispatchService(5, false) --AmbulanceDepartment
				EnableDispatchService(6, false) --PoliceRiders
				EnableDispatchService(7, false) --PoliceVehicleRequest
				EnableDispatchService(8, false) --PoliceRoadBlock
				EnableDispatchService(9, false) --PoliceAutomobileWaitPulledOver
				EnableDispatchService(10, false) --PoliceAutomobileWaitCruising
				EnableDispatchService(11, false) --Gangs
				EnableDispatchService(12, false) --SwatHelicopter
				EnableDispatchService(13, false) --PoliceBoat
				EnableDispatchService(14, false) --ArmyVehicle
				EnableDispatchService(15, false) --BikerBackup


				SetPlayerWantedLevel(playerId, 0, false)
				SetPlayerWantedLevelNow(playerId, false)
				SetPlayerWantedLevelNoDrop(playerId, 0, false)
			else
				EnableDispatchService(1, true) --PoliceAutomobile
				EnableDispatchService(2, true) --PoliceHelicopter
				EnableDispatchService(3, true) --FireDepartment
				EnableDispatchService(4, true) --SwatAutomobile
				EnableDispatchService(5, true) --AmbulanceDepartment
				EnableDispatchService(6, true) --PoliceRiders
				EnableDispatchService(7, true) --PoliceVehicleRequest
				EnableDispatchService(8, true) --PoliceRoadBlock
				EnableDispatchService(9, true) --PoliceAutomobileWaitPulledOver
				EnableDispatchService(10, true) --PoliceAutomobileWaitCruising
				EnableDispatchService(11, true) --Gangs
				EnableDispatchService(12, true) --SwatHelicopter
				EnableDispatchService(13, true) --PoliceBoat
				EnableDispatchService(14, true) --ArmyVehicle
				EnableDispatchService(15, true) --BikerBackup


				SetPlayerWantedLevel(playerId, 5, false)
				SetPlayerWantedLevelNow(playerId, false)
				SetPlayerWantedLevelNoDrop(playerId, 5, false)
			end

			--[[ PED POPULATION OFF ]]
			SetPedPopulationBudget(0)
			SetPedDensityMultiplierThisFrame(0)
			SetScenarioPedDensityMultiplierThisFrame(0, 0)

			--[[ VEHICLE POPULATION OFF ]]
			SetPedPopulationBudget(0)
			SetVehicleDensityMultiplierThisFrame(0)
			SetRandomVehicleDensityMultiplierThisFrame(0)
			SetParkedVehicleDensityMultiplierThisFrame(0)

			--[[ POLICE IGNORE PLAYER ]]
			SetPoliceIgnorePlayer(playerPed, false)
			SetDispatchCopsForPlayer(playerPed, false)

			--[[ Disable all light source on the map ]]
			SetArtificialLightsState(true)
		end
	end

)

Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(0) --Temporisation de 0 secondes
			local playerPed = GetPlayerPed(-1)
			if IsEntityDead(playerPed) and isPoliceActive then
				local player = PlayerId()
				--[ Section permettant de tuer le joueur via une explosion ]
				-- local ped = GetPlayerPed(player)
				-- local cds = GetEntityCoords(ped)
				-- AddExplosion(cds.x + 1, cds.y + 1, cds.z + 1, 72, 100.0, true, false,1.0)

				Citizen.Wait(2 * 1000) --Temporisation de 2 secondes
			
				TriggerServerEvent('killZone', GetPlayerServerId(player))	--Déclenchement de la fonction serveur "killZone"
			end
		end
	end

)

--[ Fonction d'activation des unité de police/SWAT/FBI/militaire pour tuer le joueur]
function activePolice()
	EnableDispatchService(1, true) --PoliceAutomobile
	EnableDispatchService(2, true) --PoliceHelicopter
	EnableDispatchService(3, true) --FireDepartment
	EnableDispatchService(4, true) --SwatAutomobile
	EnableDispatchService(5, true) --AmbulanceDepartment
	EnableDispatchService(6, true) --PoliceRiders
	EnableDispatchService(7, true) --PoliceVehicleRequest
	EnableDispatchService(8, true) --PoliceRoadBlock
	EnableDispatchService(9, true) --PoliceAutomobileWaitPulledOver
	EnableDispatchService(10, true) --PoliceAutomobileWaitCruising
	EnableDispatchService(11, true) --Gangs
	EnableDispatchService(12, true) --SwatHelicopter
	EnableDispatchService(13, true) --PoliceBoat
	EnableDispatchService(14, true) --ArmyVehicle
	EnableDispatchService(15, true) --BikerBackup

	SetPlayerWantedLevel(playerId, 5, false)	--Demande de réinitialisation du niveau de wanted du joueur à 5 étoiles
	SetPlayerWantedLevelNow(playerId, false)	--Exécution de la demande de réinitialisation immédiatement
	SetPlayerWantedLevelNoDrop(playerId, 5, false)	--Demande de réinitialisation du niveau de wanted du joueur à 5 étoiles sans possibilité de les perdres
end


--[ Fonction d'affichage du compte à rebours sur l'écran du joueur]
function countdown()
	--Définition des variables
	showCD = true
    local time = 5
    local scale = 0
    scale = showCountdown(time, _r, _g, _b)	--Definition du scaleform qui consititue le compte à rebours 
	PlaySoundFrontend(-1, "5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset", 1)	--Lancement du son de compte à rebours via une bibliothèque interne à GTA
	--Thread pour faire progresser le compte à rebour
    Citizen.CreateThread(function()
        while showCD do
            Citizen.Wait(1000)
            if time > 1 then
                time = time - 1
                scale = showCountdown(time, _r, _g, _b)

            elseif time == 1 then
                time = time - 1
                scale = showCountdown("GO", _r, _g, _b)

            else
                showCD = false
            end
        end
    end)
	--Thread pour afficher le compte à rebour à l'écran
    Citizen.CreateThread(function()
        while showCD do
            Citizen.Wait(0)
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

--[ Fonction d'initialisation du Scaleform qui consititue le compte à rebours ]
function showCountdown(_number, _r, _g, _b)
    local scaleform = Scaleform.Request('COUNTDOWN')

    Scaleform.CallFunction(scaleform, false, "SET_MESSAGE", _number, _r, _g, _b, true)
    Scaleform.CallFunction(scaleform, false, "FADE_MP", _number, _r, _g, _b)

    return scaleform
end

--[ Fonction de récupération du Scaleform ]
function Scaleform.Request(scaleform)
    local scaleform_handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform_handle) do
        Citizen.Wait(0)
    end
    return scaleform_handle
end

--[ Fonction de mise en forme du Scaleform ]
function Scaleform.CallFunction(scaleform, returndata, the_function, ...)
    BeginScaleformMovieMethod(scaleform, the_function)
    local args = {...}

    if args ~= nil then
        for i = 1,#args do
            local arg_type = type(args[i])

            if arg_type == "boolean" then
                ScaleformMovieMethodAddParamBool(args[i])
            elseif arg_type == "number" then
                if not string.find(args[i], '%.') then
                    ScaleformMovieMethodAddParamInt(args[i])
                else
                    ScaleformMovieMethodAddParamFloat(args[i])
                end
            elseif arg_type == "string" then
                ScaleformMovieMethodAddParamTextureNameString(args[i])
            end
        end

        if not returndata then
            EndScaleformMovieMethod()
        else
            return EndScaleformMovieMethodReturnValue()
        end
    end
end