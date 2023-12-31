-- criação do banco de dados
create database if not exists ecommerce;
use ecommerce;

drop table Cliente, Produto, Pedido, Pagamento, Estoque, Fornecedor, Vendedor, PVendedor, PPedido, ProdutoEmEstoque;

-- Criação tabela cliente
create table if not exists Cliente(
		idCliente int auto_increment,
		Primeiro_Nome varchar(90) not null, 
		Inicial_do_Nome_do_Meio varchar(5) not null,
		Sobrenome varchar(90) not null,
		CPF varchar(11),
		Endereço varchar(90) not null,
		Data_de_Nascimento date not null,
		primary key (idCliente),
		constraint unique_CPF unique (CPF)
		);
desc Cliente;

-- Criação tabela Estoque:
create table if not exists Estoque(
		idEstoque int auto_increment,
		LocaldoEstoque varchar(300) not null,
		Quantidade int not null,
        primary key (idEstoque)
		);
desc Estoque;

-- Criação tabela Produto:
create table if not exists Produto(
		idProduto int not null,
        Nome_do_Produto varchar(45) not null,
        Classificação_para_crianças bool,
        CPF_Produto varchar(11),
		Categoria enum('Eletrônico', 'Roupas', 'Brinquedos', 'Alimentos', 'Móveis'),
		Valor float not null,
        Descrição mediumtext,
        Avaliação int default null,
        Disponibilidade enum('Disponivel', 'Indisponivel') default ('Disponível'),
        tamanho_do_produto varchar(20), -- dimensão do produto
        constraint fk_Produto_CPF foreign key(CPF_Produto) references Cliente(CPF),
		primary key (idProduto)
		);
desc Produto;

-- Criação tabela Pagamento:
create table if not exists Pagamento(
		idClientePagamento int,
		idPagamento int not null,
        TipodePagamento enum('Boleto','Cartão', 'Dois cartões'),
        LimiteDisponível float,
        constraint fk_Pagamento_idCliente foreign key (idClientePagamento) references Cliente(idCliente),
        primary key(idClientePagamento, idPagamento)
		);
desc Pagamento;

-- Criação tabela Pedido:
create table if not exists Pedido(
		idPedido int auto_increment,
        idClientePedido int,
        StatusdoPedido enum('Cancelado', 'Confirmado', 'Em Processamento') default ('Em Processamento'),
        DescriçãoPedido mediumtext,
        Frete float default (10) not null,
        Pagamento bool default false,
        constraint fk_Pedido_idCliente foreign key (idClientePedido) references Cliente(idCliente),
        primary key (idPedido, idClientePedido)
        );
desc Pedido;

-- Criação tabela Fornecedor:
create table if not exists Fornecedor(
		idFornecedor int auto_increment,
		RazãoSocialFornecedor varchar(100) not null,
        CNPJ varchar(15) not null,
        Contato varchar(20) not null,
        constraint unique_Fornecedor unique(CNPJ, Contato),
        primary key (idFornecedor)
		);
desc Fornecedor;        
        
-- Criação tabela Vendedor:
create table if not exists Vendedor(
		idVendedor int auto_increment,
        RazãoSocialVendedor varchar(100) not null,
        CNPJVendedor varchar(15) not null,
        CPFVendedor varchar(11) not null,
        NomeFantasia varchar(200),
        EndereçoVendedor varchar(200) not null,
        constraint unique_vendedor unique(CNPJVendedor, CPFVendedor),
        constraint fk_Vendedor_CNPJ foreign key (CNPJVendedor) references Fornecedor(CNPJ),
        constraint fk_Vendedor_CPF foreign key (CPFVendedor) references Cliente(CPF),
        primary key(idVendedor)
		);
desc Vendedor;

-- Criação tabela Produto do Vendedor:
create table if not exists PVendedor( -- PVendedor == 'Produto do Vendedor'
		idPVendedor int,
        idPProduto int, -- IF utilizado para diferenciar do ID Produto da tabela de produto
        QuantidadeProduto int default (1),
		primary key (idPVendedor, idPProduto),
        constraint fk_Produto_Vendedor foreign key (idPVendedor) references Vendedor(idVendedor),
        constraint fk_Produto_Produto foreign key (idPProduto) references Produto(idProduto)
        );
desc PVendedor;

-- Criação tabela Produto do Pedido:
create table if not exists PPedido(
		idPPedido int, -- ID Produto Pedido
        idPProduto int, -- ID Produto do Produto
        QuantidadePedido int default (1),
        ProdutoStatusPedido enum('Disponível', 'Indisponível') default ('Disponível'),
        primary key (idPPedido, idPProduto),
        constraint fk_Produto_Pedido foreign key (idPPedido) references Pedido(idPedido),
        constraint fk_Produto_PPedido foreign key (idPProduto) references produto(idProduto)
        );
desc PPedido;

-- Criação tabela Produto em Estoque:
create table if not exists ProdutoEmEstoque(
		idProdutoEmEstoque int,
        idPProdutoEstoque int, -- ID PRODUTO DO PRODUTO NO ESTOQUE
        QuantidadeEmEstoque int,
        Localização varchar(255),
        primary key (idProdutoEmEstoque, idPProdutoEstoque),
        constraint fk_idProdutoEmEstoque foreign key (idProdutoEmEstoque) references Estoque(idEstoque),
        constraint fk_idPProdutoEstoque foreign key (idPProdutoEstoque) references Produto(idProduto)
        );
desc ProdutoEmEstoque;

show tables;
