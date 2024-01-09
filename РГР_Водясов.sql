DROP DATABASE RGR;
CREATE DATABASE RGR;
USE RGR;
DROP TABLE IF EXISTS department, positions, project, employe_programs, employe;

    CREATE TABLE `department` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `name` varchar(200) NOT NULL,
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `employe` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `department_id` INT NOT NULL,
        `position_id` INT NOT NULL,
        `name` varchar(150) NOT NULL,
        `male` bool NOT NULL,
        `age` smallint NOT NULL,
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `positions` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `position_name` varchar(100) NOT NULL,
        PRIMARY KEY (`id`)
    );


    CREATE TABLE `project` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `employe_id` INT NOT NULL,
        `department_id` INT NOT NULL,
        `project_date` DATE NOT NULL,
        `project_title` varchar(200) NOT NULL DEFAULT 'unknown_project',
        `project_description` TEXT NOT NULL,
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `employe_programs` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `employe_id` INT NOT NULL,
        `program_name` varchar(100) NOT NULL,
        `login` varchar(75) NOT NULL DEFAULT '-',
        `password` varchar(20) NOT NULL DEFAULT '-',
        `access` bool NOT NULL DEFAULT false,
        PRIMARY KEY (`id`)
    );


    ALTER TABLE `employe` ADD CONSTRAINT `employe_fk0` FOREIGN KEY (`department_id`) REFERENCES `department`(`id`);

    ALTER TABLE `employe` ADD CONSTRAINT `employe_fk1` FOREIGN KEY (`position_id`) REFERENCES `positions`(`id`);

    ALTER TABLE `project` ADD CONSTRAINT `project_fk0` FOREIGN KEY (`employe_id`) REFERENCES `employe`(`id`);

    ALTER TABLE `project` ADD CONSTRAINT `project_fk1` FOREIGN KEY (`department_id`) REFERENCES `employe`(`department_id`);

    ALTER TABLE `employe_programs` ADD CONSTRAINT `employe_programs_fk0` FOREIGN KEY (`employe_id`) REFERENCES `employe`(`id`);


DROP TRIGGER IF EXISTS project_insert;
DELIMITER //
CREATE TRIGGER project_insert BEFORE INSERT ON project
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employe.id) FROM employe WHERE employe.id = NEW.employe_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot insert this employe_id. Such employe was not found.';
END IF;
IF (NEW.department_id != (SELECT employe.department_id FROM employe WHERE employe.id = NEW.employe_id))
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'This employe does not belong to this department';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS employe_insert;
DELIMITER //
CREATE TRIGGER employe_insert BEFORE INSERT ON employe
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(department.id) FROM department WHERE department.id = NEW.department_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such department_id.';
END IF;
IF ((SELECT COUNT(positions.id) FROM positions WHERE positions.id = NEW.position_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such position_id.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS employe_programs_insert;
DELIMITER //
CREATE TRIGGER employe_programs_insert BEFORE INSERT ON employe_programs
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employe.id) FROM employe WHERE employe.id = NEW.employe_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such employe_id.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS project_update;
DELIMITER //
CREATE TRIGGER project_update BEFORE UPDATE ON project
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employe.id) FROM employe WHERE employe.id = NEW.employe_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot update this employe_id. Such employe was not found.';
END IF;

IF (NEW.department_id != (SELECT employe.department_id FROM employe WHERE employe.id = NEW.employe_id))
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'This employe does not belong to this department';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS employe_update;
DELIMITER //
CREATE TRIGGER employe_update BEFORE UPDATE ON employe
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(department.id) FROM department WHERE department.id = NEW.department_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such department_id.';
END IF;
IF ((SELECT COUNT(positions.id) FROM positions WHERE positions.id = NEW.position_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such position_id.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS employe_programs_update;
DELIMITER //
CREATE TRIGGER employe_programs_update BEFORE UPDATE ON employe_programs
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employe.id) FROM employe WHERE employe.id = NEW.employe_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such employe_id.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS employe_programs_update;
DELIMITER //
CREATE TRIGGER employe_delete BEFORE DELETE ON employe
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employe_programs.employe_id) FROM employe_programs WHERE employe_programs.employe_id = OLD.id) != 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'You cannot delete this employe. Because it is in the table employe_programs. Remove it from employe_programs table first.';
END IF;
IF ((SELECT COUNT(project.employe_id) FROM project WHERE project.employe_id = OLD.id) != 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'You cannot delete this employe. Because it is in the table project. Remove it from project table first.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS department_delete;
DELIMITER //
CREATE TRIGGER department_delete BEFORE DELETE ON department
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employe.department_id) FROM employe WHERE employe.department_id = OLD.id) != 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'You cannot delete this department. Because some employees are attached to him.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS positions_delete;
DELIMITER //
CREATE TRIGGER positions_delete BEFORE DELETE ON positions
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employe.position_id) FROM employe WHERE employe.position_id = OLD.id) != 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'You cannot delete this position. Because some employees are attached to him.';
END IF;
END //
DELIMITER ;
