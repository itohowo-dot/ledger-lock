/**
 * WalletConnect Configuration for Stacks Integration
 * https://docs.walletconnect.network/wallet-sdk/web/installation
 */

export const walletConnectConfig = {
  projectId: process.env.WALLETCONNECT_PROJECT_ID || '', // Get from https://cloud.walletconnect.com
  metadata: {
    name: 'State-Keeper Protocol',
    description: 'State-Keeper Protocol - Stacks DApp',
    url: 'https://ledger-lock.com', // Update with your actual URL
    icons: ['https://ledger-lock.com/icon.png'], // Update with your actual icon
  },
  // Deployed contract address
  contractAddress: 'SP3P2G9ZK7B309EGAM9QAM143YGDNBGGQAXDAS1GW.ledger-lock',
  // Stacks chain configuration
  chains: {
    stacks: {
      mainnet: {
        chainId: 'stacks:mainnet',
        name: 'Stacks Mainnet',
        rpc: 'https://stacks-node-api.mainnet.stacks.co',
      },
      testnet: {
        chainId: 'stacks:testnet',
        name: 'Stacks Testnet',
        rpc: 'https://stacks-node-api.testnet.stacks.co',
      },
      devnet: {
        chainId: 'stacks:devnet',
        name: 'Stacks Devnet',
        rpc: 'http://localhost:3999',
      },
    },
  },
};

export type StacksNetwork = 'mainnet' | 'testnet' | 'devnet';

export interface StacksAddress {
  symbol: string;
  address: string;
}

export interface WalletConnectSession {
  topic: string;
  addresses: StacksAddress[];
  network: StacksNetwork;
}
