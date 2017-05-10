USE `gta5_gamemode_essential`;

INSERT INTO `jobs` (`name`, `label`) VALUES
('cop', 'LSPD');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('cop', 0, 'cadet', 'Cadet', 500, '{"tshirt_1":57,"torso_1":55,"arms":0,"pants_1":35,"glasses":0,"decals_2":0,"hair_color_2":0,"helmet_2":0,"hair_color_1":5,"face":19,"glasses_2":1,"torso_2":0,"shoes":24,"hair_1":2,"skin":34,"sex":0,"glasses_1":0,"pants_2":0,"hair_2":0,"decals_1":0,"tshirt_2":0,"helmet_1":8}', '{"tshirt_1":34,"torso_1":48,"shoes":24,"pants_1":34,"torso_2":0,"decals_2":0,"hair_color_2":0,"glasses":0,"helmet_2":0,"hair_2":3,"face":21,"decals_1":0,"glasses_2":1,"hair_1":11,"skin":34,"sex":1,"glasses_1":5,"pants_2":0,"arms":14,"hair_color_1":10,"tshirt_2":0,"helmet_1":57}'),
('cop', 1, 'agent', 'Agent', 650, '{"tshirt_1":58,"torso_1":55,"arms":30,"pants_1":35,"glasses":0,"decals_2":0,"hair_color_2":0,"helmet_2":0,"hair_color_1":5,"face":19,"glasses_2":1,"torso_2":0,"shoes":24,"hair_1":2,"skin":34,"sex":0,"glasses_1":0,"pants_2":0,"hair_2":0,"decals_1":8,"tshirt_2":0,"helmet_1":11}', '{"tshirt_1":35,"torso_1":48,"shoes":24,"pants_1":34,"torso_2":0,"decals_2":0,"hair_color_2":0,"glasses":0,"helmet_2":0,"hair_2":3,"face":21,"decals_1":7,"glasses_2":1,"hair_1":11,"skin":34,"sex":1,"glasses_1":5,"pants_2":0,"arms":44,"hair_color_1":10,"tshirt_2":0,"helmet_1":57}'),
('cop', 2, 'sergeant', 'Sergent', 750, '{"tshirt_1":58,"torso_1":55,"shoes":24,"pants_1":35,"pants_2":0,"decals_2":1,"hair_color_2":0,"face":19,"helmet_2":0,"hair_2":0,"arms":0,"decals_1":8,"torso_2":0,"hair_1":2,"skin":34,"sex":0,"glasses_1":0,"glasses_2":1,"hair_color_1":5,"glasses":0,"tshirt_2":0,"helmet_1":11}', '{"tshirt_1":35,"torso_1":48,"arms":14,"pants_1":34,"pants_2":0,"decals_2":1,"hair_color_2":0,"shoes":24,"helmet_2":0,"hair_2":3,"decals_1":7,"torso_2":0,"face":21,"hair_1":11,"skin":34,"sex":1,"glasses_1":5,"glasses_2":1,"hair_color_1":10,"glasses":0,"tshirt_2":0,"helmet_1":57}'),
('cop', 3, 'lance_sergeant', 'Sergent Chef', 850, '{"tshirt_1":58,"torso_1":55,"arms":41,"pants_1":35,"face":19,"decals_2":1,"hair_color_2":0,"torso_2":0,"helmet_2":0,"hair_2":0,"shoes":24,"decals_1":8,"glasses_2":1,"hair_1":2,"skin":34,"sex":0,"glasses_1":0,"pants_2":0,"glasses":0,"hair_color_1":5,"tshirt_2":0,"helmet_1":11}', '{"tshirt_1":35,"torso_1":48,"shoes":24,"pants_1":34,"glasses_2":1,"decals_2":1,"hair_color_2":0,"torso_2":0,"helmet_2":0,"hair_2":3,"arms":44,"decals_1":7,"hair_color_1":10,"hair_1":11,"skin":34,"sex":1,"glasses_1":5,"pants_2":0,"glasses":0,"face":21,"tshirt_2":0,"helmet_1":57}'),
('cop', 4, 'lieutenant', 'Lieutenant', 1000, '{"tshirt_1":58,"torso_1":55,"shoes":24,"pants_1":35,"pants_2":0,"decals_2":2,"hair_color_2":0,"face":19,"helmet_2":0,"hair_2":0,"glasses":0,"decals_1":8,"hair_color_1":5,"hair_1":2,"skin":34,"sex":0,"glasses_1":0,"glasses_2":1,"torso_2":0,"arms":41,"tshirt_2":0,"helmet_1":11}', '{"tshirt_1":35,"torso_1":48,"arms":44,"pants_1":34,"hair_2":3,"decals_2":2,"hair_color_2":0,"hair_color_1":10,"helmet_2":0,"face":21,"shoes":24,"torso_2":0,"glasses_2":1,"hair_1":11,"skin":34,"sex":1,"glasses_1":5,"pants_2":0,"decals_1":7,"glasses":0,"tshirt_2":0,"helmet_1":57}'),
('cop', 5, 'captain', 'Capitaine', 1200, '{"tshirt_1":58,"torso_1":55,"shoes":24,"pants_1":35,"pants_2":0,"decals_2":3,"hair_color_2":0,"face":19,"helmet_2":0,"hair_2":0,"arms":41,"torso_2":0,"hair_color_1":5,"hair_1":2,"skin":34,"sex":0,"glasses_1":0,"glasses_2":1,"decals_1":8,"glasses":0,"tshirt_2":0,"helmet_1":11}', '{"tshirt_1":35,"torso_1":48,"arms":44,"pants_1":34,"pants_2":0,"decals_2":3,"hair_color_2":0,"face":21,"helmet_2":0,"hair_2":3,"decals_1":7,"torso_2":0,"hair_color_1":10,"hair_1":11,"skin":34,"sex":1,"glasses_1":5,"glasses_2":1,"shoes":24,"glasses":0,"tshirt_2":0,"helmet_1":57}');

CREATE TABLE `fine_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `fine_types` (`label`, `amount`, `category`) VALUES
('Usage abusif du klaxon', 30, 0),
('Absence de clignotant', 30, 0),
('Franchir une ligne continue', 40, 0),
('Circulation à contresens', 250, 0),
('Demi-tour non autorisé', 250, 0),
('Circulation hors-route', 170, 0),
('Non-respect des distances de sécurité', 30, 0),
('Arrêt dangereux / interdit', 150, 0),
('Stationnement gênant / interdit', 70, 0),
('Non respect  de la priorité à droite', 70, 0),
('Non-respect à un véhicule prioritaire', 200, 0),
('Non-respect d''un stop', 250, 0),
('Non-respect d''un feu rouge', 600, 0),
('Dépassement dangereux', 540, 0),
('Véhicule non en état', 540, 0),
('Conduite sans permis', 1500, 0),
('Délit de fuite', 800, 0),
('Excès de vitesse < 5 mph', 275, 0),
('Excès de vitesse 5-10 mph', 540, 0),
('Excès de vitesse 10-15 mph', 600, 0),
('Excès de vitesse > 20 mph', 700, 0),
('Entrave de la circulation', 250, 1),
('Dégradation de la voie publique', 800, 1),
('Trouble à l''ordre publique', 800, 1),
('Entrave opération de police', 850, 1),
('Complicité', 850, 1),
('Insulte envers / entre civils', 500, 1),
('Outrage à agent de police', 800, 1),
('Menace verbale ou intimidation envers civil', 500, 1),
('Menace verbale ou intimidation envers policier', 850, 1),
('Manifestation illégale', 850, 1),
('Tentative de corruption', 1500, 1),
('Arme blanche sortie en ville', 300, 2),
('Arme léthale sortie en ville', 600, 2),
('Port d''arme non autorisé (défaut de license)', 600, 2),
('Port d''arme illégal', 700, 2),
('Pris en flag lockpick', 150, 2),
('Vol de voiture', 900, 2),
('Vente de drogue', 1000, 2),
('Fabriquation de drogue', 1500, 2),
('Possession de drogue', 900, 2),
('Prise d''ôtage civil', 1500, 2),
('Prise d''ôtage agent de l''état', 2000, 2),
('Braquage particulier', 800, 2),
('Braquage magasin', 600, 2),
('Braquage de banque', 1500, 2),
('Tir sur civil', 2000, 3),
('Tir sur agent de l''état', 2500, 3),
('Tentative de meurtre sur civil', 1000, 3),
('Tentative de meurtre sur agent de l''état', 1500, 3),
('Meurtre sur civil', 1000, 3),
('Meurte sur agent de l''état', 3000, 3),
('Meurtre involontaire', 700, 3);

CREATE TABLE `fines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) DEFAULT NULL,
  `fine_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
);