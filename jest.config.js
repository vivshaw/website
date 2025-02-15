/** @type {import('@jest/types').Config.InitialOptions} */
const config = {
  roots: ['test/javascript'],
  setupFilesAfterEnv: ['./test/javascript/setupTests.js'],
  moduleNameMapper: {
    '^[./a-zA-Z0-9$_-]+\\.svg$':
      '<rootDir>/app/javascript/images/GlobalImageStub.js',
    'manifest.json$': '<rootDir>/app/javascript/__mocks__/fileMock.js',
    '@/(.*)': '<rootDir>/app/javascript/$1',
    '\\.(css)$': 'identity-obj-proxy',
  },
  testEnvironment: 'jsdom',
}

module.exports = config
