--CASE 

SELECT 
A1_COD,
A1_LOJA,
A1_NOME,

CASE A1_PESSOA 
WHEN 'F' THEN 'F�SICA'
WHEN 'J' THEN 'JUR�DICA'
END A1_PESSOA


FROM SA1990


