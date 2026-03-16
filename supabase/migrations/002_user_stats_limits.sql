-- Migration 002: Ajout de statistiques et suivi pour limiter à 1 action / jour

-- Ajout des colonnes sur public.users
ALTER TABLE public.users 
ADD COLUMN IF NOT EXISTS last_sent_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS last_received_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS active_days_streak INT DEFAULT 0;

-- Fonction pour incrémenter le streak lors d'une action
CREATE OR REPLACE FUNCTION public.increment_streak_if_new_day() 
RETURNS trigger AS $$
BEGIN
    -- Si first time ou difference entre today et last_active est 1 jour -> streak + 1
    -- Si > 1 jour -> reset streak à 1
    -- Si même jour -> garde le même streak.
    -- (Cette logique sera gérée plutôt côté client ou avec une logique spécifique 
    -- lors des calls update. On garde ces colonnes simples pour l'instant).
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
