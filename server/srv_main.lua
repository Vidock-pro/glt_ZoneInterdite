-- Import des commandes ESX
ESX = nil
ESX = exports["es_extended"]:getSharedObject()

-- Fonction serveur 'KillZone'
RegisterNetEvent('killZone')
AddEventHandler('killZone', function(playerId)
    -- récupération de l'id du joueur et stockage dans une variable (xPlayer) local à la fonction 
    local xPlayer = ESX.GetPlayerFromId(playerId)

    -- Log pour indiquer la mort du personnage dans la console serveur
    print("Le personnage "..tostring(xPlayer.identifier).." a été tué hors de la zone de jeu")

    --Kick du joueur du serveur avec un message lui indiquant la raison
    xPlayer.kick("🔨 Non respect du règlement, personnage supprimé ⚰️")

    --Commande SQL pour désactiver son personnage
	MySQL.update('UPDATE `users` SET `disabled` = 1 WHERE identifier = ?', {
		xPlayer.identifier
	})
end)