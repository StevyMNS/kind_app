-- ============================================
-- One Kind Message — Migration initiale
-- ============================================

-- 1. Table users
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Table messages
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  content TEXT NOT NULL CHECK (char_length(content) <= 200),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Table deliveries
CREATE TABLE IF NOT EXISTS public.deliveries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id UUID NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  receiver_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  delivered_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(message_id, receiver_id)
);

-- Index pour les performances
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON public.messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON public.messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_deliveries_receiver_id ON public.deliveries(receiver_id);
CREATE INDEX IF NOT EXISTS idx_deliveries_message_id ON public.deliveries(message_id);

-- ============================================
-- RLS (Row Level Security)
-- ============================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.deliveries ENABLE ROW LEVEL SECURITY;

-- Users: peut lire/insérer son propre enregistrement
CREATE POLICY "users_insert_own" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "users_select_own" ON public.users
  FOR SELECT USING (auth.uid() = id);

-- Messages: peut insérer ses propres messages
CREATE POLICY "messages_insert_own" ON public.messages
  FOR INSERT WITH CHECK (auth.uid() = sender_id);

-- Messages: peut lire ses messages envoyés
CREATE POLICY "messages_select_sent" ON public.messages
  FOR SELECT USING (auth.uid() = sender_id);

-- Messages: peut lire les messages qui lui ont été livrés
CREATE POLICY "messages_select_received" ON public.messages
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.deliveries
      WHERE deliveries.message_id = messages.id
        AND deliveries.receiver_id = auth.uid()
    )
  );

-- Deliveries: peut insérer des livraisons pour soi-même
CREATE POLICY "deliveries_insert_own" ON public.deliveries
  FOR INSERT WITH CHECK (auth.uid() = receiver_id);

-- Deliveries: peut lire ses propres livraisons
CREATE POLICY "deliveries_select_own" ON public.deliveries
  FOR SELECT USING (auth.uid() = receiver_id);

-- ============================================
-- Fonction RPC : matching aléatoire
-- ============================================

CREATE OR REPLACE FUNCTION public.get_random_unread_message(user_id_param UUID)
RETURNS SETOF public.messages
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT m.*
  FROM public.messages m
  WHERE m.sender_id != user_id_param
    AND m.id NOT IN (
      SELECT d.message_id
      FROM public.deliveries d
      WHERE d.receiver_id = user_id_param
    )
  ORDER BY random()
  LIMIT 1;
$$;
