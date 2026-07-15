export const hoodbetTheme = {
  colors: {
    primary: '#00C805',
    primaryDark: '#008C04',
    background: '#0A0A0A',
    surface: '#111111',
    text: '#FFFFFF',
    muted: '#A0A0A0',
    gold: '#FFD700',
    border: 'rgba(255,255,255,0.08)',
  },
  fonts: {
    body: "'Inter', system-ui, sans-serif",
    display: "'Space Grotesk', system-ui, sans-serif",
  },
}

export const robinhoodChain = {
  id: 4663,
  name: 'Robinhood Chain',
  nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 },
  rpcUrls: {
    default: { http: ['https://rpc.mainnet.chain.robinhood.com'] },
  },
  blockExplorers: {
    default: { name: 'Blockscout', url: 'https://robinhoodchain.blockscout.com' },
  },
}

export const addresses = {
  safe: '0x5FF989aCB81e612fb54d2BDE9C6334B4C9a8f117',
  morphoVault: '0xDF06045aBAE69d6e73a7F0197FED917032d22194',
  usdg: '0x5fc5360D0400a0Fd4f2af552ADD042D716F1d168',
  hoodRng: '0x8B6EdfeCe14210eCb2A8D28F333D81621103Dd19',
  prizePool: '0x14e5004a757a85439fc379c8acd5b3b3cdf47344',
  prizeVault: '0x11da9bE66d20328c6eA16d52079890322fA90f24',
  drawManager: '0xd1c3d3b690c9a2033b0bea03ba0771847fd983eb',
  twabController: '0x534eb000af980efe5dc8f7b1b579c3c4baf87942',
  hoodFeeHarvester: '0x3632Dd39B2717602fB4d7f79D001c3a51625159d',
  claimer: '0x71ec0971e8f8e35568a4bbe0fc118e6ca0ebe707',
  hoodToken: '0x3b4b9E8982449aa6712F0d13162252A4a871D43e',
  hoodPoints: '0x7EBb6063C98e2D9faAD4C67A99d6A259f7810901',
}

export const subgraphUrl =
  'https://api.goldsky.com/api/public/project_cmmaz8bs32rjv01u29b8y8vuf/subgraphs/hoodbet/1.0.0/gn'

export const links = {
  app: 'https://app.hoodbet.fun',
  landing: 'https://hoodbet.fun',
  docs: 'https://hoodbet.gitbook.io/hoodbet-docs',
  github: 'https://github.com/hoodbet-fun',
  telegram: 'https://t.me/+8KdjgSVzZr5hZjc0',
  x: 'https://x.com/hoodbet_fun',
  virtuals: 'https://app.virtuals.io/virtuals/105591',
  morphoVault:
    'https://app.morpho.org/robinhood-chain/vault/0xDF06045aBAE69d6e73a7F0197FED917032d22194/hoodbetfun',
  subgraph:
    'https://api.goldsky.com/api/public/project_cmmaz8bs32rjv01u29b8y8vuf/subgraphs/hoodbet/1.0.0/gn',
}

export const tierThresholds = [
  { name: 'Scout', min: 0, multiplier: '1×', color: '#A0A0A0' },
  { name: 'Hood', min: 10_000, multiplier: '1.25×', color: '#00C805' },
  { name: 'Legend', min: 100_000, multiplier: '1.5×', color: '#FFD700' },
  { name: 'OG', min: 1_000_000, multiplier: '2×', color: '#FFD700' },
]
