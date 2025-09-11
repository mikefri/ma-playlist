# Définir le chemin de base pour les URLs
$base_url = "https://mikefri.github.io/ma-playlist/"

# Créer un tableau vide pour stocker les chansons
$playlist_items = @()

# Parcourir tous les fichiers .mp3 dans le dossier actuel
Get-ChildItem -Path (Get-Location) -Filter "*.mp3" | ForEach-Object {
    $file_name = $_.Name

    # Enlever l'extension .mp3 pour obtenir le titre brut
    $name_without_ext = [System.IO.Path]::GetFileNameWithoutExtension($file_name)

    # Séparer l'artiste et le titre par le premier ' - '
    $parts = $name_without_ext.Split(" - ", 2)
    $artist = $parts[0].Trim()
    $title = $parts[1].Trim()

    # Remplacer les espaces par %20 pour l'URL
    $url_encoded_filename = $file_name.Replace(" ", "%20")
    $path = "$base_url$url_encoded_filename"
    
    # Créer un objet PowerShell pour la chanson
    $song_object = @{
        title = $title;
        artist = $artist;
        path = $path;
        sample_rate = "";
        artist_image = "";
    }

    # Ajouter l'objet à la liste de lecture
    $playlist_items += [pscustomobject]$song_object
}

# Convertir la liste en JSON et l'enregistrer dans un fichier
$playlist_items | ConvertTo-Json -Depth 5 | Set-Content -Path "audios-list.json"

Write-Host "Le fichier audios-list.json a été créé avec succès !"