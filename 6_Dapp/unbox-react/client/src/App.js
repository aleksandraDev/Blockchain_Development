import React, { Component } from 'react';
import SimpleStorageContract from './contracts/SimpleStorage.json';
import getWeb3 from './getWeb3';

import './App.css';

class App extends Component {
	state = { storageValue: 0, web3: null, accounts: null, contract: null, events: [] };

	componentDidMount = async () => {
		try {
			// Get network provider and web3 instance.
			const web3 = await getWeb3();

			// Use web3 to get the user's accounts.
			const accounts = await web3.eth.getAccounts();

			// Get the contract instance.
			const networkId = await web3.eth.net.getId();
			const deployedNetwork = SimpleStorageContract.networks[networkId];
			const instance = new web3.eth.Contract(
				SimpleStorageContract.abi,
				deployedNetwork && deployedNetwork.address
			);

			// Set web3, accounts, and contract to the state, and then proceed with an
			// example of interacting with the contract's methods.
			this.setState({ web3, accounts, contract: instance }, this.runExample);
		} catch (error) {
			// Catch any errors for any of the above operations.
			alert(`Failed to load web3, accounts, or contract. Check console for details.`);
			console.error(error);
		}
	};

	runExample = async () => {
		const { accounts, contract } = this.state;

		// Stores a given value, 5 by default.
		const event = await contract.methods.set(42).send({ from: accounts[0] });

		// Get the value from the contract to prove it worked.
		const response = await contract.methods.get().call();

		// Update state with the result.
		this.setState({ storageValue: response, events: [...this.state.events, event] });
	};

	render() {
		console.log('events', this.state.events);
		if (!this.state.web3) {
			return <div>Loading Web3, accounts, and contract...</div>;
		}
		return (
			<div className="App">
				<h1>Good to Go!</h1>
				<p>Your Truffle Box is installed and ready.</p>
				<h2>Smart Contract Example</h2>
				<p>
					If your contracts compiled and migrated successfully, below will show a stored value of 5
					(by default).
				</p>
				<p>
					Try changing the value stored on <strong>line 42</strong> of App.js.
				</p>
				<div>The stored value is: {this.state.storageValue}</div>
				<div className="App-eventWrapper">
					{this.state.events.map((e) => (
						<ul className="App-events" key={e.blockNumber}>
							<li className="App-event">Transaction Hash: {e.transactionHash}</li>
							<li className="App-event">From : {e.from}</li>
							<li className="App-event">To: {e.to}</li>
							<li className="App-event">Gas used : {e.gasUsed}</li>
							<br />
							<li className="App-event">Event : {e.events.StoredValue.event}</li>
							<li className="App-event">Address : {e.events.StoredValue.address}</li>
							<li className="App-event">BlockHash : {e.events.StoredValue.blockHash}</li>
							<li className="App-event">BlockNumber : {e.events.StoredValue.blockNumber}</li>
							<li className="App-event">Signature : {e.events.StoredValue.signature}</li>
							<li className="App-event">
								Returned values : {JSON.stringify(e.events.StoredValue.returnValues)}
							</li>
						</ul>
					))}
				</div>
			</div>
		);
	}
}

export default App;
