pragma solidity ^0.4.24;
/**
* @title ERC20Interface
* @author Tomado del código de Fabian Vogelsteller, Vitalik Buterin
* @dev Este contrato fue modificado por Alex Montoya
 */
contract ERC20Interface {
    /* This is a slight change to the ERC20 base standard.
    function totalSupply() constant returns (uint256 supply);
    is replaced with:
    uint256 public totalSupply;
    This automatically creates a getter function for the totalSupply.
    This is moved to the base contract since public getter functions are not
    currently recognised as an implementation of the matching abstract
    function by the compiler.
    */
    /// Returns the total token supply.
    uint256 public totalSupply;

    /// Returns the name of the token - e.g. "MyToken"
    string public name;

    ///Returns the symbol of the token. E.g. "HIX".
    string public symbol;


    ///Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000 to get its user representation.
    uint8 public decimals;


    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public view returns (uint256 balance);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    // solhint-disable-next-line no-simple-event-func-name
    /**
    * @dev MUST trigger when tokens are transferred, including zero value transfers.
    * @notice A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.
    * @param _from origin address
    * @param _to destination address (recipient)
    * @param _value number of tokens
    */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /** MUST trigger on any successful call to approve(address _spender, uint256 _value).*/
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/**
* @title StandardToken
* @notice Implementacion del estándar ERC20 para el manejo de tokens
 */
contract StandardToken is ERC20Interface{
    ///Balance de cada usuario
    mapping (address => uint256) balances;

    ///Usuarios a los que se les permite usar tokens de otro usuario
    mapping (address => mapping (address => uint256)) allowed;

    //Número total de Tokens
    uint256 public totalSupply;

    constructor(string tokenName, string tokenSymbol) public {
        name = tokenName;
        symbol = tokenSymbol;
    }


    /**
    * @notice indica el balance (número de tokens) que tiene el usuario indicado.
    * @param tokenOwner dirección del usuario del que se quieren conocer los tokens
    * @return el balance actual del usuario
    */
    function balanceOf(address tokenOwner) public view returns (uint balance){
        return balances[tokenOwner];
    }

    /**
    * @notice indica cuántos tokens tiene permitido usar el cliente indicado
    * @param tokenOwner la dirección que permite que se use un número de sus tokens
    * @param spender la dirección a la qu se le permite usar un número de tokens
    */
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    /**
    * @notice transfiere un número de tokens a la dirección indicada
    * @dev la dirección origen es la que invoca el contrato (msg.sender)
    * @dev al final del proceso se emite un mensaje de transferencia
    * @param to dirección a la que se transfieren los tokens
    * @param tokens el número de tokens que se tranfieren
    * @return el resultado de la operación (true normalmente)
    */
    function transfer(address to, uint tokens) public returns (bool success) {
        transfer(msg.sender, to, tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }


    /**
    * @notice transfiere tokens de una dirección a otra
    * @dev se debe verificar si la dirección origen tiene permitido usar el número de tokens indicado
    * @param from la dirección origen de los tokens (debe permiter que el emisor use tokens)
    * @param to dirección a la que se envían tokens
    * @param tokens número de tokens que se envían
    * @return el resultado de la operación (true normalmente)
    */
    function transferFrom(address from, address to, uint tokens) public returns (bool success){
        //se valida que se tenga permitido realizar el envío de tokens y que se permita envíae el número indicado
        require(allowed[from][msg.sender] >= tokens);

        transfer(from, to, tokens);
        allowed[from][msg.sender] -= tokens;
        emit Transfer(from, to, tokens);
        return true;
    }

    function transfer(address from, address to, uint tokens) internal {
        //burning ether
        require(to != 0x0);

        //se validan overflows
        require(balances[to] + tokens >= balances[to]);

        //se valida que se tenga el saldo suficiente y que se envíe un número válido de tokens
        require(balances[from] >= tokens && tokens > 0);

        balances[from] -= tokens;
        balances[to] += tokens;
    }

    /**
    * @notice permite que una dirección use tokens de otra dirección.
    * @dev la dirección que permite el envío de tokens es quien invoca el contrato (msg.sender)
    * @param spender la dirección a la que se le permite usar los tokens
    * @param tokens el número de tokens que se permitirá que se usen
    * @return el resultado de la operación (true normalmente)
    */
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
}