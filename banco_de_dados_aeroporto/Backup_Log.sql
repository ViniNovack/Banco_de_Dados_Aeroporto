-- ________________________________________________Backup e Log________________________________________________
/*
10.2 Configuração de Backup e Log
Para o banco de dados do gerenciamento aeroportuário, propõe-se uma política de backup e recuperação com o objetivo de preservar as 
informações operacionais e administrativas, garantindo a continuidade das atividades em caso de falhas, perdas de dados ou exclusões acidentais.

Frequência de Backup:
Será realizado um backup completo diariamente, preferencialmente às 02h, período escolhido por representar um horário de menor movimentação operacional, 
reduzindo possíveis impactos sobre o desempenho do sistema durante a realização da cópia de segurança.
Além disso, serão mantidas cópias semanais e mensais para arquivamento de longo prazo, permitindo recuperar versões anteriores do banco caso algum problema não seja identificado imediatamente.

Tipo de Backup:
Será utilizado o backup completo (Full Backup), responsável por copiar integralmente o banco de dados, incluindo suas tabelas e respectivos registros.
Escolhemos esse tipo de backup porque ele facilita o processo de recuperação, uma vez que não depende da combinação de diversos arquivos de cópias incrementais ou diferenciais. 
Além disso, considerando que o sistema armazena informações relacionadas entre si, como operações de rota, operações de solo, infraestrutura e incidentes operacionais, a cópia integral
facilita a restauração de todo o banco, preservando a consistência dos relacionamentos. Embora exija mais espaço de armazenamento e tempo para sua execução, essa abordagem oferece maior 
simplicidade de administração e recuperação, sendo adequada para a organização simulada.

Política de Logs:
Será proposta a ativação do Binary Log (Binlog) do MySQL, responsável por registrar continuamente as alterações realizadas no banco de dados, incluindo operações de inserção, atualização e exclusão de registros.
Os arquivos de log serão mantidos por um período de 30 dias, com acesso restrito aos administradores do banco de dados. Esse período foi escolhido para oferecer uma janela de recuperação caso algum problema seja 
identificado dias após sua ocorrência, sem exigir o armazenamento indefinido dos arquivos. A utilização dos logs é importante porque os backups diários representam apenas uma cópia do banco em determinado momento, 
não registrando individualmente todas as alterações realizadas posteriormente. Com o Binary Log, é possível manter o histórico dessas modificações e utilizá-lo para recuperar informações em situações de falha.

Recuperação de Desastres (Point-in-Time Recovery):
Em caso de perda ou alteração indevida de informações, será possível utilizar o backup completo mais recente em conjunto com os registros do Binary Log 
para recuperar o banco de dados até um momento específico, anterior à ocorrência do problema. Essa estratégia foi escolhida porque permite recuperar as 
informações sem precisar retornar exclusivamente ao estado do último backup, evitando a perda de todas as operações realizadas desde sua execução. Por exemplo, 
caso um funcionário exclua acidentalmente uma operação de rota, será possível restaurar o backup anterior e reaplicar as transações registradas nos logs até imediatamente antes da exclusão. 
Dessa forma, preservam-se as operações realizadas durante o período e evita-se a perda de informações importantes para o funcionamento e o histórico operacional do aeroporto.
Por fim, recomenda-se armazenar as cópias de segurança em um local separado do servidor principal, reduzindo o risco de perda simultânea dos dados originais e dos backups 
em caso de falha ou incidente, além de realizar testes periódicos de restauração para verificar a integridade das cópias e garantir a eficácia do procedimento de recuperação.
*/